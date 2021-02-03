class CreateApprovalKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :approval_kinds do |t|
      t.text :title
      t.integer :workflow_id
      t.text :for_class
      # this is the base link, the actual identifier will be found via a model method
      t.text :object_link
      t.timestamps
    end
  end
end
