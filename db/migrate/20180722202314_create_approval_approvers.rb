class CreateApprovalApprovers < ActiveRecord::Migration[5.1]
  def change
    create_table :approval_approvers do |t|
      t.references :approval
      t.references :user
      t.references :approval_type

      t.datetime :last_notified
      t.boolean :required, default: true
      t.text :decline_reason
      t.timestamps
    end
  end
end
