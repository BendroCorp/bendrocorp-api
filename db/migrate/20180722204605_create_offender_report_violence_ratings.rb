class CreateOffenderReportViolenceRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :offender_report_violence_ratings do |t|
      t.text :title
      t.text :description
      t.string :color
      t.timestamps
    end
  end
end
