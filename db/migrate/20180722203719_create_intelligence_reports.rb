class CreateIntelligenceReports < ActiveRecord::Migration[5.1]
  def change
    create_table :intelligence_reports do |t|
      t.text :title
      t.text :description
      t.text :tags

      t.belongs_to :classification_level
      t.belongs_to :submitted_by

      t.belongs_to :offender_report_offender
      t.belongs_to :offender_report_org
      t.timestamps
    end
  end
end
