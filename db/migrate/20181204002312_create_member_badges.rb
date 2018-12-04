class CreateMemberBadges < ActiveRecord::Migration[5.1]
  def change
    create_table :member_badges do |t|
      t.belongs_to :user
      t.belongs_to :badge
      t.timestamps
    end
  end
end
