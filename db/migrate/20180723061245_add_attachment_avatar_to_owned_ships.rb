class AddAttachmentAvatarToOwnedShips < ActiveRecord::Migration[5.1]
  def self.up
    change_table :owned_ships do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :owned_ships, :avatar
  end
end
