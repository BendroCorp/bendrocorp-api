class CreateProfileGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :profile_groups, id: :uuid do |t|
      t.belongs_to :division, null: false, foreign_key: true
      t.belongs_to :parent, null: false, foreign_key: true, type: :uuid
      t.text :title
      t.text :description
      t.integer :ordinal

      t.timestamps
    end
  end
end
