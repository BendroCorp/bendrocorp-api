class AddAttachmentImageToSystemMapImages < ActiveRecord::Migration[5.1]
  def self.up
    change_table :system_map_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :system_map_images, :image
  end
end
