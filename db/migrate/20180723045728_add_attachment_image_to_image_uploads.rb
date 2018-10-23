class AddAttachmentImageToImageUploads < ActiveRecord::Migration[5.1]
  def self.up
    change_table :image_uploads do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :image_uploads, :image
  end
end
