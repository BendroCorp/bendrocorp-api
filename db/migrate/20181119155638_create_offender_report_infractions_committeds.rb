class CreateOffenderReportInfractionsCommitteds < ActiveRecord::Migration[5.1]
  def change
    create_table :offender_report_infractions_committeds do |t|
      t.belongs_to :infraction
      t.belongs_to :report
      t.timestamps
    end
  end
end
