class AdjustPaperclipColumnNames < ActiveRecord::Migration[6.1]
  def change
    change_table :characters do |t|
      t.rename :avatar_file_name, :avatar_old_file_name
      t.rename :avatar_content_type, :avatar_old_content_type
      t.rename :avatar_file_size, :avatar_old_file_size
      t.rename :avatar_updated_at, :avatar_old_updated_at
    end

    change_table :image_uploads do |t|
      t.rename :image_file_name, :image_old_file_name
      t.rename :image_content_type, :image_old_content_type
      t.rename :image_file_size, :image_old_file_size
      t.rename :image_updated_at, :image_old_updated_at
    end

    change_table :system_map_images do |t|
      t.rename :image_file_name, :image_old_file_name
      t.rename :image_content_type, :image_old_content_type
      t.rename :image_file_size, :image_old_file_size
      t.rename :image_updated_at, :image_old_updated_at
    end
  end
end
