class CreateProfileGroupMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :profile_group_members, id: :uuid do |t|
      t.text :member_title
      t.belongs_to :character, foreign_key: true
      t.belongs_to :profile_group, type: :uuid, foreign_key: true
      t.boolean :ordinal

      t.timestamps
    end
  end
end
