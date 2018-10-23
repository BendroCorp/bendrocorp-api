class CreateApprovals < ActiveRecord::Migration[5.1]
  def change
    create_table :approvals do |t|
      t.references :approval_kind
      t.boolean :full_consent, default: false
      t.boolean :denied, default: false
      t.boolean :approved, default: false
      t.timestamps
    end
  end
end
