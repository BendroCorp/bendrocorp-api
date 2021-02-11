class CreateReportFieldValues < ActiveRecord::Migration[5.1]
  def change
    create_table :report_field_values, id: :uuid do |t|
      t.text :value
      # t.belongs_to :report, type: :uuid, index: false
      t.belongs_to :field, type: :uuid, index: false
      t.timestamps
    end

    # add_index :report_field_values, [:field, :report], unique: true
  end
end
