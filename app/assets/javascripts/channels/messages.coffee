App.messages = App.cable.subscriptions.create 'MessagesChannel',
  received: (data) ->
    $("#messages").removeClass('hidden')
    return $("#messages-" + data.chatroom_id).append(data.message)

# This fixes a problem with jQuery and Turbolinks which causes document ready to only work the first time landing on a
# page, because that's the only time it actually loads. This gets around that problem.  See:
# http://guides.rubyonrails.org/working_with_javascript_in_rails.html#turbolinks

# Sending messages out can be done with an ActionCable send, or a regular Ajax form post.
# It's not clear which one is beter.

$(document).on 'turbolinks:load', ->
  $('textarea#message_content').keydown (event) ->
    if (event.keyCode == 13)
      msg = event.target.value
      room_id = $("#room_identifier").data("room-id")
      App.messages.send({message: msg, chatroom_id: room_id})
      $('[data-textarea="message"]').val(" ")
      return false
