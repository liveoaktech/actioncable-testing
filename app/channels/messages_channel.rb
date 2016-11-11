class MessagesChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'messages'
  end

  def receive(payload)
    Message.create(user: current_user, room_id: payload["room_id"], content: payload["message"])
  end
end
