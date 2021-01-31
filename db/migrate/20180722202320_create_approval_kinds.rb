class CreateApprovalKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :approval_kinds do |t|
      t.text :title
      t.integer :workflow_id
      t.text :for_class
      t.timestamps
    end
  end
end
