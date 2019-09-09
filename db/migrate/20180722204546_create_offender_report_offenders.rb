class CreateOffenderReportOffenders < ActiveRecord::Migration[5.1]
  def change
    create_table :offender_report_offenders do |t|
      t.text :offender_name
      t.text :offender_handle
      t.boolean :offender_handle_verified
      t.text :offender_rsi_url
      t.text :offender_rsi_avatar
      t.integer :offender_rating_percentage #a pg proc will compute this which will be triggered by a record saving

      t.belongs_to :offender_rating
      t.belongs_to :offender_report_org

      # offender specific org items
      t.integer :offender_org_rank
      t.text :org_title

      # 
      t.boolean :dont_scrape, default: false
      t.timestamps
    end
  end
end
