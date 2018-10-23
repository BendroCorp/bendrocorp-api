class CreateInRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :in_roles do |t|
      t.belongs_to :user, index: true
      t.belongs_to :role, index: true
      t.timestamps
    end
  end
end
