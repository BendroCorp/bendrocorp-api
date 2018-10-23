class CreateRoleRemovalRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :role_removal_requests do |t|
      t.references :user
      t.references :role
      t.references :approval

      t.references :on_behalf_of
      t.timestamps
    end
  end
end
