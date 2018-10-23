class CreateOffenderReportApprovalRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :offender_report_approval_requests do |t|
      t.belongs_to :offender_report
      t.belongs_to :approval
      t.belongs_to :user
      t.timestamps
    end
  end
end
