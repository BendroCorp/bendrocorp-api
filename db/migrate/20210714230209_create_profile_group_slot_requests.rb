class CreateProfileGroupSlotRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :profile_group_slot_requests, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :character, null: false, foreign_key: true
      t.belongs_to :profile_group_slot, null: false, foreign_key: true, type: :uuid
      t.belongs_to :approval, null: false, foreign_key: true

      t.timestamps
    end
  end
end
