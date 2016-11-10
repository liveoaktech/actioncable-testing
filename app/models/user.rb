class User < ApplicationRecord
  has_many :messages
  has_many :chatrooms, through: :messages

  validates :username, presence: true, uniqueness: true

  def self.find_for_login(name)
    where("lower(username) = ?", name.downcase).first
  end

  def appear(data={})
    logger.debug "user #{ self.id } appearing with:  #{ data }"
  end

  def disappear
    logger.debug "user #{ self.id } disappearing"
  end
end
