class CreateProfileGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :profile_groups, id: :uuid do |t|
      t.belongs_to :division, null: false, foreign_key: true
      t.belongs_to :parent, null: false, foreign_key: true, type: :uuid
      t.belongs_to :manager_slot, foreign_key: { to_table: :profile_group_slots }, type: :uuid
      t.belongs_to :created_by, null: false, foreign_key: { to_table: :users }
      t.text :title, null: false
      t.text :description
      t.integer :ordinal, null: false

      t.boolean :archived, null: false, default: false

      t.timestamps
    end
  end
end
