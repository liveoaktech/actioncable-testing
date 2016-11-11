class PresenceBroadcastJob < ApplicationJob

  queue_as :default

  def perform(user, room_id)
    ActionCable.server.broadcast 'presence', { presence: render_presence(room_id), room_id: room_id }
  end

  private

  def render_presence(room_id)
    users = RoomUser.where(room_id: room_id).map{|ru| ru.user}
    ApplicationController.renderer.render(partial: 'rooms/presence', locals: { users: users })
  end
end
