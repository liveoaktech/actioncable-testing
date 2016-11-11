class PresenceChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'presence'
    # current_user.appear this isn't useful unless we can get room info too
  end

  def unsubscribed
    # This could be a problem, unless we can get the room_id here, since user could theoretically be in multiple rooms
    current_user.disappear
  end

  def appear(data)
    # Create presence in some kind of presence table with entries belonging to user and room
    RoomUser.find_or_create_by room_id: data['room_id'], user_id: current_user.id do |room_user|
      room_user.status = 'present'
    end
    current_user.appear room_id: data['room_id']
  end

  def receive(payload)
    logger.debug "PresenceChannel received #{ payload.inspect }"
  end
end
