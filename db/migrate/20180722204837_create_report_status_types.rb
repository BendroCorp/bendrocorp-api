class CreateReportStatusTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :report_status_types do |t|
      t.text :title
      t.text :description
      t.timestamps
    end
  end
end
