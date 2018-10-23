class CreateRoleRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :role_requests do |t|
      # need to add refences for on behalf of
      # http://stackoverflow.com/questions/14867981/how-do-i-add-migration-with-multiple-references-to-the-same-model-in-one-table
      t.references :user
      t.references :role
      t.references :approval

      t.references :on_behalf_of
      t.timestamps
    end
  end
end
