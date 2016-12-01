class MessagesChannel < ApplicationCable::Channel  

  def subscribed
    # create a room-specific channel for messages, using the same technique as presence
    logger.debug "Setting instance variable @room_id = #{ params[:room_id] } from params: #{ params }"
    @room_id = params[:room_id]
    stream_from "room-#{params[:room_id]}:messages"
  end

  # Probably don't need to do anything here in the real app
  def unsubscribed
    logger.debug "Messages channel unsubscribed in room ID #{ @room_id }"
  end

  # TODO - we don't need to pass room_id in the message because it should be unique to the stream
  def receive(payload)
    Message.create(user: current_user, room_id: payload["room_id"], content: payload["message"])
  end
end
