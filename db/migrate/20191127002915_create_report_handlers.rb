class CreateReportHandlers < ActiveRecord::Migration[5.1]
  def change
    create_table :report_handlers do |t|
      t.text :name
      t.timestamps
    end
  end
end
