class PresenceChannel < ApplicationCable::Channel
  def subscribed
    # This supposedly makes the channel unique to a specific room - but it doesn't seem to work
    # room = Room.find_by(slug: params[:slug])
    # stream_for room

    stream_from 'presence'
    # Adding the user here isn't possible unless we can get room info too.
    # The presence messages exist entirely so we can send one message out containing the room ID.
    # current_user.appear
  end

  def unsubscribed
    # This seems like the most reliable place to take the user out of the room.
    # This could be a problem, unless we can get the room_id here, since user could theoretically be in multiple rooms.
    # current_user.disappear
  end

  def appear(data)
    logger.debug "Server presenceChannel appear with data:  #{ data }"
    return unless data['room_id'].present?
    # Add/update the user's entry in the presence table
    begin
      room_user = RoomUser.find_or_create_by room_id: data['room_id'], user_id: current_user.id
      room_user.update_attribute :status, RoomUser::UP
    rescue ActiveRecord::RecordNotUnique => e
      logger.error "Rescued attempt to create duplicate room_user"
    end

    current_user.broadcast_presence room_id: data['room_id'], status: RoomUser::UP
  end

  def disappear(data)
    logger.debug "Server presenceChannel disappear with data:  #{ data }"
    return unless data['room_id'].present?
    # update the user's entry in the presence table
    room_user = RoomUser.find_by room_id: data['room_id'], user_id: current_user.id
    room_user.update_attribute :status, RoomUser::DOWN if room_user.present?

    current_user.broadcast_presence room_id: data['room_id'], status: RoomUser::DOWN
  end

  def receive(payload)
    logger.debug "PresenceChannel for user #{ current_user.username } received #{ payload.inspect }"
  end
end
