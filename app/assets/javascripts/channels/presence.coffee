App.presence = App.cable.subscriptions.create "PresenceChannel",

  install: ->
    $(document).on "turbolinks:load.presence", =>
      @appear()

  uninstall: ->
    $(document).off(".presence")

  # Called when the subscription is ready for use on the server
  connected: ->
    @install()
    @appear()

  # Called when the WebSocket connection is closed
  disconnected: ->
    @uninstall()

  # Called when the subscription is rejected by the server
  rejected: ->
    @uninstall()

  appear: ->
    # Calls `PresenceChannel#appear(data)` on the server with the room ID from the DOM
    room_id = $("#room_identifier").data("room-id")
    user_id = $("#room_identifier").data("user-id")
    # This calls appear in the presence_channel with the room_id
    @perform("appear", room_id: room_id)
    # Tell everybody else we're here
    App.presence.send({user_id: user_id, room_id: room_id})

  received: (data) ->
    return $("#presence-indicators-" + data.room_id).append(data.presence)
