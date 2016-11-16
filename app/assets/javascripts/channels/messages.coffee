App.messages = App.cable.subscriptions.create 'MessagesChannel',
  received: (data) ->
    $("#messages").removeClass('hidden')
    return $("#messages-" + data.room_id).append(data.message)

# If we were using Turbolinks, document ready wouldn't work here.  See:
# http://guides.rubyonrails.org/working_with_javascript_in_rails.html#turbolinks

# Sending messages out can be done with an ActionCable send, or a regular Ajax form post.
# It's not clear which one is beter.

$(document).ready ->
  $('textarea#message_content').keydown (event) ->
    if (event.keyCode == 13)
      msg = event.target.value
      room_id = $("#room_identifier").data("room-id")
      App.messages.send({message: msg, room_id: room_id})
      $('[data-textarea="message"]').val(" ")
      return false
