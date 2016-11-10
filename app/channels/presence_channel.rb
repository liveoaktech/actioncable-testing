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
    current_user.appear room_id: data['room_id']
    # Create presence in some kind of presence table with entries belonging to user and room
    # Presence.create user: user, room: room, other_stuff: stuff
  end

  def receive(payload)
    logger.debug "PresenceChannel received #{ payload.inspect }"
  end
end
