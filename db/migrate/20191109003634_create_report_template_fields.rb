class CreateReportTemplateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :report_template_fields, id: :uuid do |t|
      t.belongs_to :template
      t.text :name
      t.text :description
      t.text :validator
      t.integer :field_presentation_type_id # 1 = Text, 2 = Long Text (text area), 3 = Number, 4 = Date, 5 = Field
      t.belongs_to :field, type: :uuid
      t.belongs_to :report_handler_variable, type: :uuid
      t.boolean :required, default: false
      t.integer :ordinal
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
