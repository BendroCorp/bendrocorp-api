class CreateApproverRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :approver_roles do |t|
      t.belongs_to :approval_kind, index:true
      t.belongs_to :role, index:true
      t.timestamps
    end
  end
end
