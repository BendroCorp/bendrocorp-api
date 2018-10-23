class CreateNestedRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :nested_roles do |t|
      t.belongs_to :role
      t.belongs_to :role_nested
      t.timestamps
    end
  end
end
