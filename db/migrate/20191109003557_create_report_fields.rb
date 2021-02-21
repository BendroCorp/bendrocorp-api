class CreateReportFields < ActiveRecord::Migration[5.1]
  def change
    create_table :report_fields, id: :uuid do |t|
      t.belongs_to :report, type: :uuid
      t.text :name
      t.text :description
      t.text :validator
      t.text :default_value
      t.integer :field_presentation_type_id # 1 = Text, 2 = Long Text, 3 = Number, 4 = Date, 5 = Field
      t.belongs_to :field, type: :uuid
      t.belongs_to :report_handler_variable, type: :uuid
      t.boolean :required
      t.integer :ordinal
      t.boolean :hidden
      t.timestamps
    end
  end
end
