class CreatePageImages < ActiveRecord::Migration[5.1]
  def change
    create_table :page_images, id: :uuid do |t|
      t.belongs_to :page, type: :uuid
      t.belongs_to :image_upload
      t.timestamps
    end
  end
end
