class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.text :title
      t.text :description

      t.boolean :submitted
      t.boolean :returned, default: 0
      t.boolean :approved, default: 0

      t.belongs_to :submitter
      t.belongs_to :specified_submit_to_role
      t.belongs_to :report_type
      t.belongs_to :flight_log
      t.belongs_to :report_approval_request
      t.belongs_to :report_status_type
      t.timestamps
    end
  end
end
