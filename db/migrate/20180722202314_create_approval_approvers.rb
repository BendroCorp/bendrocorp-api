class CreateApprovalApprovers < ActiveRecord::Migration[5.1]
  def change
    create_table :approval_approvers do |t|
      t.references :approval
      t.references :user
      t.references :approval_type
      t.timestamps
    end
  end
end
