class PresenceBroadcastJob < ApplicationJob

  queue_as :default

  def perform(user, room_id, status)
    ActionCable.server.broadcast "room-#{room_id}:presence", { username: user.username, user_id: user.id, room_id: room_id, status: status }
  end
end
