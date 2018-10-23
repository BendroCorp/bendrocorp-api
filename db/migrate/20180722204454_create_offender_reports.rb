class CreateOffenderReports < ActiveRecord::Migration[5.1]
  def change
    create_table :offender_reports do |t|
      t.text :description
      t.boolean :report_approved
      t.boolean :submitted_for_approval, default: false
      t.belongs_to :created_by

      t.datetime :occured_when

      #refs
      t.belongs_to :violence_rating
      t.belongs_to :offender
      t.belongs_to :ship
      t.belongs_to :system
      t.belongs_to :planet
      t.belongs_to :moon
      t.belongs_to :system_object
      t.belongs_to :settlement
      t.belongs_to :location
      t.belongs_to :offender_report_approval_request

      t.boolean :archived, default: false

      t.belongs_to :classification_level
      t.timestamps
    end
  end
end
