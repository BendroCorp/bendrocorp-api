class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.text :name
      t.text :description
      t.integer :max_users, default: 0
      t.text :discord_role_id
      t.timestamps
    end
  end
end
