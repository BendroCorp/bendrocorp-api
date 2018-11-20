class CreateOffenderReportInfractions < ActiveRecord::Migration[5.1]
  def change
    create_table :offender_report_infractions do |t|
      t.text :title
      t.text :description
      t.belongs_to :violence_rating
      t.timestamps
    end
  end
end
