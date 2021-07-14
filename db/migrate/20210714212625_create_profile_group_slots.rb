class CreateProfileGroupSlots < ActiveRecord::Migration[6.1]
  def change
    create_table :profile_group_slots, id: :uuid do |t|
      t.belongs_to :profile_group, null: false, foreign_key: true, type: :uuid
      t.belongs_to :character, null: false, foreign_key: true
      t.belongs_to :role, null: false, foreign_key: true
      t.text :title
      t.integer :ordinal
      t.boolean :exempt

      t.timestamps
    end
  end
end
