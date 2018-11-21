class CreateOffenderReportOrgs < ActiveRecord::Migration[5.1]
  def change
    create_table :offender_report_orgs do |t|
      t.text :title
      t.text :spectrum_id
      t.text :description
      t.integer :member_count
      t.string :model
      t.string :commitment
      t.string :primary_activity
      t.string :secondary_activity
      t.belongs_to :violence_rating
      t.text :logo
      t.timestamps
    end
  end
end
