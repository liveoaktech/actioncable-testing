class RoomUser < ApplicationRecord

  belongs_to :room
  belongs_to :user

  # Currently, these correspond to classes in the view "connection-xxx"
  NEVER   = "never"
  UP      = "up"
  DOWN    = "down"
  WARNING = "warning"

  STATUSES = [ NEVER, UP, DOWN, WARNING ]

  # Does anything else need to live here?
end
