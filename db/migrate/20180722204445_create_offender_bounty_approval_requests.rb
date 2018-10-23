class CreateOffenderBountyApprovalRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :offender_bounty_approval_requests do |t|
      t.belongs_to :user #required field/fk
      t.belongs_to :approval #required field/fk
      t.belongs_to :offender_bounty
      t.timestamps
    end
  end
end
