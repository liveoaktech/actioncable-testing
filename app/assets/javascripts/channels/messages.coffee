App.cable.subscriptions.create 'MessagesChannel',
  received: (data) ->
    $("#messages").removeClass('hidden')
    return $('#messages').append(this.renderMessage(data))

  renderMessage: (data) ->
    return "<p> <b>" + data.user + ": </b>" + data.message + "</p>"
