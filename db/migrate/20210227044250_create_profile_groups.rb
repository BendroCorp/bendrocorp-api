class CreateProfileGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :profile_groups, id: :uuid do |t|
      t.text :title
      t.text :description
      t.text :banner_color
      t.belongs_to :parent, type: :uuid #, foreign_key: true
      t.integer :ordinal
      t.integer :depth
      t.boolean :archived

      t.timestamps
    end
  end
end
