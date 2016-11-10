class User < ApplicationRecord
  has_many :messages
  has_many :chatrooms, through: :messages

  validates :username, presence: true, uniqueness: true

  def self.find_for_login(name)
    where("lower(username) = ?", name.downcase).first
  end

  def appear(data={})
    # There is perhaps no reason to tie this to user
    logger.debug "user #{ self.id } appearing with:  #{ data }"
    # this could be done in PresenceChannel#receive as ActionCable.server.broadcast(blah)
    PresenceBroadcastJob.perform_now self, data[:room_id]
  end

  def disappear
    logger.debug "user #{ self.id } disappearing"
  end
end
