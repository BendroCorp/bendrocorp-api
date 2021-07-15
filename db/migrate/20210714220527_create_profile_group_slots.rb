class CreateProfileGroupSlots < ActiveRecord::Migration[6.1]
  def change
    create_table :profile_group_slots, id: :uuid do |t|
      t.belongs_to :profile_group, null: false, foreign_key: true, type: :uuid
      t.belongs_to :character, foreign_key: true
      t.belongs_to :slot_status, null: false, foreign_key: { to_table: :field_descriptors }, type: :uuid, default: 'c68e5642-79cf-435f-964d-8460d9c4a895'
      t.belongs_to :role, foreign_key: true
      t.belongs_to :created_by, null: false, foreign_key: { to_table: :users }
      t.text :title
      t.integer :ordinal, null: false
      t.boolean :exempt, default: false
      t.boolean :first_warn, default: false
      t.boolean :second_warn, default: false

      t.datetime :last_assigned

      t.boolean :archived, null: false, default: false

      t.timestamps
    end
  end
end
