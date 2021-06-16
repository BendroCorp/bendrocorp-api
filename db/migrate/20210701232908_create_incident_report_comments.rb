class CreateIncidentReportComments < ActiveRecord::Migration[6.1]
  def change
    create_table :incident_report_comments, id: :uuid do |t|
      t.text :comment
      t.belongs_to :created_by, null: false, foreign_key: { to_table: :users }
      t.belongs_to :incident_report, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
