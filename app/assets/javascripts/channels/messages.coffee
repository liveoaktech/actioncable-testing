App.messages = App.cable.subscriptions.create 'MessagesChannel',
  received: (data) ->
    $("#messages").removeClass('hidden')
    return $("[data-chatroom='" + data.chatroom_id + "']").append(data.message)

  renderMessage: (data) ->
    return "<p> <b>" + data.user + ": </b>" + data.message + "</p>"
