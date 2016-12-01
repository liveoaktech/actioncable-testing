# Handle messages uniquely per room, in the same way presence is handled.
# Items passed after the channel name are exposed on the Ruby side as a params hash. We have to put this inside a
# document.ready block - otherwise it will load too early and the jQuery lookup of room-id will fail.
$(document).ready ->
  App.messages = App.cable.subscriptions.create { channel: 'MessagesChannel', room_id: $("#room_identifier").data('room-id') },
    install: ->
      console.log "messages channel method @install"

    connected: ->
      console.log "messages channel method @connected"
      # Scroll to the bottom of messages, in case the room already has enough messages to fill the window
      pane = $("#messages")
      pane.scrollTop(pane.prop("scrollHeight"))

    received: (data) ->
      console.log "messages channel method @received"
      pane = $("#messages")  # we don't need to make the DOM ID unique to room if messages are going only to the right browser
      pane.removeClass('hidden')
      pane.append(data.message)
      pane.scrollTop(pane.prop("scrollHeight"))   # bump scrolling every time we add a message - LO Activity window already does this with chatify(text)
      return true

  # If we were using Turbolinks, document ready wouldn't work here.  See:
  # http://guides.rubyonrails.org/working_with_javascript_in_rails.html#turbolinks

  # Sending messages out can be done with an ActionCable send, or a regular Ajax form post.
  # It's not clear which one is beter.
  $('textarea#message_content').keydown (event) ->
    if (event.keyCode == 13)
      msg = event.target.value
      room_id = $("#room_identifier").data("room-id")
      App.messages.send({message: msg, room_id: room_id})
      $('[data-textarea="message"]').val(" ")
      return false
