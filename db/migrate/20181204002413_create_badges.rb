class CreateBadges < ActiveRecord::Migration[5.1]
  def change
    create_table :badges do |t|
      t.text :title
      t.text :image_link
      t.integer :ordinal
      t.belongs_to :created_by
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
