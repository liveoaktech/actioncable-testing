class RenameChatroomToRoom < ActiveRecord::Migration[5.0]
  # Rename chatrooms to rooms, because it's super annoying
  def up
    rename_table "chatrooms", "rooms"
    rename_column "messages", :chatroom_id, :room_id
  end

  def down
    rename_table "rooms", "chatrooms"
    rename_column "messages", :room_id, :chatroom_id
  end
end
