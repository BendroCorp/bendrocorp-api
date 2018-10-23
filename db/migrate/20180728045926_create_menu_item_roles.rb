class CreateMenuItemRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :menu_item_roles do |t|
      t.belongs_to :menu_item
      t.belongs_to :role
      t.timestamps
    end
  end
end
