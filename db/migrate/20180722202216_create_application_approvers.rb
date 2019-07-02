class CreateApplicationApprovers < ActiveRecord::Migration[5.1]
  def change
    create_table :application_approvers do |t|
      t.references :application
      t.references :user
      t.references :approval_type
      t.datetime :last_notified
      t.timestamps
    end
  end
end
