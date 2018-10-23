class CreateDivisionInGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :division_in_groups do |t|
      t.text :group_member_title
      t.belongs_to :character
      t.belongs_to :division_group
      t.timestamps
    end
  end
end
