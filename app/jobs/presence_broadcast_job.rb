class PresenceBroadcastJob < ApplicationJob

  queue_as :default

  def perform(user, room_id)
    ActionCable.server.broadcast 'presence', { presence: render_presence(user), room_id: room_id }
  end

  private

  def render_presence(user)
    ApplicationController.renderer.render(partial: 'rooms/presence', locals: { user: user })
  end
end
