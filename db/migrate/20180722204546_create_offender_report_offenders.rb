class CreateOffenderReportOffenders < ActiveRecord::Migration[5.1]
  def change
    create_table :offender_report_offenders do |t|
      t.text :offender_name
      t.text :offender_handle
      t.boolean :offender_handle_verified
      t.text :offender_rsi_url
      t.integer :offender_rating_percentage #a pg proc will compute this which will be triggered by a record saving

      t.belongs_to :offender_rating
      t.belongs_to :offender_report_org
      t.timestamps
    end
  end
end
