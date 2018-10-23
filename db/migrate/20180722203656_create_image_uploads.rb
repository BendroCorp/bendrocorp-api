class CreateImageUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :image_uploads do |t|
      t.text :title
      t.text :description
      t.belongs_to :uploaded_by
      t.timestamps
    end
  end
end
