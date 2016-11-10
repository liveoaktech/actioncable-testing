App.presence = App.cable.subscriptions.create "PresenceChannel",

  install: ->
    $(document).on "turbolinks:load.presence", =>
      @appear()

    $(document).on "click.presence", buttonSelector, =>
      @away()
      false

    $(buttonSelector).show()

  uninstall: ->
    $(document).off(".presence")
    $(buttonSelector).hide()

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
    # Calls `PresenceChannel#appear(data)` on the server
    @perform("appear", room_id: $("#room_identifier").data("room-id"))

  away: ->
    # Calls `PresenceChannel#away` on the server
    @perform("away")


  buttonSelector = "[data-behavior~=appear_away]"

