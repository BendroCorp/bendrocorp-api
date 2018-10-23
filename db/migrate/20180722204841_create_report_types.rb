class CreateReportTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :report_types do |t|
      t.text :title
      t.text :description

      t.belongs_to :submit_to_role
      t.timestamps
    end
  end
end
