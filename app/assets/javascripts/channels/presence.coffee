# Items passed after the channel name are exposed on the Ruby side as a params hash. We have to put this inside a
# document.ready block - otherwise it will load too early and the jQuery lookup of room-id will fail.
$(document).ready ->
  App.presence = App.cable.subscriptions.create { channel: "PresenceChannel", room_id: $("#room_identifier").data('room-id') },

    install: ->
      console.log "presence channel method @install"
      # Turbolinks breaks jQuery document ready - some of that complexity is skipped because we're not using Turbolinks
      $(document).ready =>
        @appear()

    uninstall: ->
      console.log "presence channel method @uninstall"
      # TODO - figure out whether it's possible to distinguish between disconnect due to leaving the page vs. disconnect
      #        due to connectivity, and change the status to warn rather than down, and attempt to reconnect.
      room_id = $("#room_identifier").data("room-id")
      user_id = $("#room_identifier").data("user-id")
      # stop_all_streams  # may want to try this to avoid weird multiple-streams problems
      # Changle the appearance of the current user
      $("#connection-status-" + user_id).removeClass("connection-never connection-up connection-warning connection-down");
      $("#connection-status-" + user_id).addClass("connection-down");
      # Then tell everybody else we left - goes through the user model to queue a broadcast
      @perform("disappear", room_id: room_id)

    # Called when the subscription is ready for use on the server
    connected: ->
      console.log "presence channel method @connected"
      @install()
      #@appear()  calling this after install seems to cause a lot of duplicate messages, but not calling it seems to leave messages sometimes unsent

    # Called when the WebSocket connection is closed
    disconnected: ->
      console.log "presence channel method @disconnected"
      @uninstall()

    # Called when the subscription is rejected by the server
    rejected: ->
      console.log "presence channel method @rejected"
      @uninstall()

    appear: ->
      console.log "presence channel method @appear"
      room_id = $("#room_identifier").data("room-id")
      user_id = $("#room_identifier").data("user-id")
      # This calls appear in the presence_channel with the room_id, which goes through the user model to broadcast the presence message
      @perform("appear", room_id: room_id)

    received: (data) ->
      console.log "presence channel method @appear"
      if $("#userContainer-" + data.user_id).length
        console.log "update is for an existing user: ", data
        # Change the class of the connection status indicator
        $("#connection-status-" + data.user_id).removeClass("connection-never connection-up connection-warning connection-down");
        $("#connection-status-" + data.user_id).addClass("connection-#{ data.status }");
      else if $("#room_identifier").data("user-id") == data.user_id
        console.log "update is for publisher (ignored): ", data
      else
        console.log "update is for a new user: ", data
        # The user is being dynamically added - in the real app, we clone the hidden DIV "participant_template" and
        # adjust it to fit the new user. Here we just jam something in for demo purposes.
        name = data.username
        $("#subscribers").append('<div id="userContainer-' + data.user_id + '"><div id="userBar-"' + data.user_id + '"><div id="userLabel-"' + data.user_id + '"><span class="connection-' + data.status + '">•</span> <span class="labelName" id="label-' + data.user_id + '">' + name + '</span></div></div></div>' )
      return true
