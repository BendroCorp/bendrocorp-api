class CreateOffenderReportForceLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :offender_report_force_levels do |t|
      t.text :title
      t.text :description
      t.integer :ordinal
      t.timestamps
    end
  end
end
