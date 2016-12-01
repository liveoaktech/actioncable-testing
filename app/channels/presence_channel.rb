class PresenceChannel < ApplicationCable::Channel
  # This hangs around in memory as long as the channel stays open (unlike a controller request).
  # So don't do anything in here to raise the memory footprint unnecessarily.

  def subscribed
    # Persist the room in the channel instance is created so we can refer to it later - most crucially at exit.
    # The presence channel JS must be activated only upon entering the room, otherwise the ID won't be present.
    # TODO - need to check can access room here in LO
    logger.debug "Setting instance variable @room_id = #{ params[:room_id] } from params: #{ params }"
    @room_id = params[:room_id]
    # This supposedly makes the channel unique to a specific room - but it doesn't seem to work.
    # Sending messages only to the right room would be preferable - currently they go to every room and get
    # filtered by the JS check for matching room_id - which introduces massive unnecessary overhead.
    # stream_for @room
    stream_from "room-#{params[:room_id]}:presence"
  end

  def unsubscribed
    # This seems like the most reliable place to take the user out of the room.
    # This could be a problem, unless we can get the room_id here, since user could theoretically be in multiple rooms.
    logger.debug "Presence channel unsubscribed in room ID #{ @room_id }"
    disappear room_id: @room_id
  end

  # This gets called by the client side JS
  def appear(data)
    logger.debug "Server presenceChannel appear with data:  #{ data }, @room: #{ @room } -- #{ data['room_id'] }"
    return unless data['room_id'].present?
    # Add/update the user's entry in the presence table - maybe this should be a single call to RoomUser?
    begin
      room_user = RoomUser.find_or_create_by room_id: data['room_id'], user_id: current_user.id
      room_user.update_attribute :status, RoomUser::UP
    rescue ActiveRecord::RecordNotUnique => e
      logger.error "Rescued attempt to create duplicate room_user"
    end

    PresenceBroadcastJob.perform_now current_user, data['room_id'], RoomUser::UP
  end

  def disappear(data)
    logger.debug "Server presenceChannel disappear with data:  #{ data } -- #{ data[:room_id] }"
    return unless data[:room_id].present?
    # update the user's entry in the presence table
    room_user = RoomUser.find_by room_id: data[:room_id], user_id: current_user.id
    room_user.update_attribute :status, RoomUser::DOWN if room_user.present?

    PresenceBroadcastJob.perform_now current_user, data[:room_id], RoomUser::DOWN
  end

  def receive(payload)
    logger.debug "PresenceChannel for user #{ current_user.username } received #{ payload.inspect }"
  end
end
