class User < ApplicationRecord
  has_many :messages
  has_many :rooms, through: :messages
  has_many :room_users

  validates :username, presence: true, uniqueness: true

  def self.find_for_login(name)
    where("lower(username) = ?", name.downcase).first
  end

  # There is perhaps no reason to tie this to user - maybe broadcast directly from the presence channel?
  # Left here for now, used directly in presence channel though
  def broadcast_presence(data={})
    logger.debug "user #{ self.id } appearing with:  #{ data }"
    # this could be done in PresenceChannel#receive as ActionCable.server.broadcast(blah)
    PresenceBroadcastJob.perform_now self, data[:room_id], data[:status]
  end
end
