class CreateApplicantApprovalRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :applicant_approval_requests do |t|
      t.belongs_to :user #required field/fk
      t.belongs_to :approval #required field/fk
      t.belongs_to :application
      t.timestamps
    end
  end
end
