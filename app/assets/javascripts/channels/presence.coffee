App.presence = App.cable.subscriptions.create channel: "PresenceChannel",
  # It's supposed to be possible to append a key here when creating the channel that limits access to the channel
  # in presence_channel.rb - doesn't seem to work. It's supposed to look like this:
  #  room_id: $("#room_identifier").data('room-id'),

  install: ->
    # Turbolinks breaks jQuery document ready - subsequent visits to the page won't regiseter as loads.
    # Using turbolinks:load solves this problem.  Using the "fat arrow" here is a shortcut to define this and call this.appear
    $(document).on "turbolinks:load.presence", =>
      @appear()

  uninstall: ->
    room_id = $("#room_identifier").data("room-id")
    user_id = $("#room_identifier").data("user-id")
    # Changle the appearance of the current user
    $("connection-status-" + user_id).removeClass("connection-never", "connection-up", "connection-warning", "connection-down");
    $("connection-status-" + user_id).addClass("connection-down");
    # Then tell everybody else we left - goes through the user model to queue a broadcast
    @perform("disappear", room_id: room_id)

  # Called when the subscription is ready for use on the server
  connected: ->
    @install()
    #@appear()  calling this after install seems to cause a lot of duplicate messages, but not calling it seems to leave messages sometimes unsent

  # Called when the WebSocket connection is closed
  disconnected: ->
    @uninstall()

  # Called when the subscription is rejected by the server
  rejected: ->
    @uninstall()

  appear: ->
    room_id = $("#room_identifier").data("room-id")
    user_id = $("#room_identifier").data("user-id")
    # This calls appear in the presence_channel with the room_id, which goes through the user model to broadcast the presence message
    @perform("appear", room_id: room_id)

  received: (data) ->
    if $("#userContainer-" + data.user_id).length
      console.log "Upate is for an existing user: ", data
      # Change the class of the connection status indicator
      $("connection-status-" + data.user_id).removeClass("connection-never", "connection-up", "connection-warning", "connection-down");
      $("connection-status-" + data.user_id).addClass("connection-up");
    else if $("#room_identifier").data("user-id") == data.user_id
      console.log "Update is for publisher: ", data
    else
      console.log "Upate is for a new user: ", data
      # The user is being dynamically added - in the real app, we clone the hidden DIV "participant_template" and
      # adjust it to fit the new user. Here we just jam something in for demo purposes.
      name = data.username
      $("#subscribers").append('<div id="userContainer-' + data.user_id + '"><div id="userBar-"' + data.user_id + '"><div id="userLabel-"' + data.user_id + '"><span class="connection-up">•</span> <span class="labelName" id="label-' + data.user_id + '">' + name + '</span></div></div></div>' )
    return true
