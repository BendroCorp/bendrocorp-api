class CreateReportApprovalRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :report_approval_requests do |t|
      t.belongs_to :user #required field/fk
      t.belongs_to :approval #required field/fk
      t.belongs_to :report
      t.timestamps
    end
  end
end
