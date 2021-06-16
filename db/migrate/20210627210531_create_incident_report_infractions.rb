class CreateIncidentReportInfractions < ActiveRecord::Migration[6.1]
  def change
    create_table :incident_report_infractions, id: :uuid do |t|
      t.belongs_to :incident_report, null: false, foreign_key: true, type: :uuid
      t.belongs_to :infraction, null: false, foreign_key: { to_table: :field_descriptors }, type: :uuid

      t.timestamps
    end
  end
end
