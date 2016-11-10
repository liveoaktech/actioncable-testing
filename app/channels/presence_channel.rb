class PresenceChannel < ApplicationCable::Channel
  def subscribed
    current_user.appear
  end

  def unsubscribed
    current_user.disappear
  end

  def appear(data)
    current_user.appear room_id: data['room_id']
  end

  def away
    current_user.away
  end
end