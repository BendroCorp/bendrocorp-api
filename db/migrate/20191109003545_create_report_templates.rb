class CreateReportTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :report_templates, id: :uuid do |t|
      t.text :name
      t.text :description
      t.boolean :draft, default: true
      t.belongs_to :handler
      t.belongs_to :created_by
      t.belongs_to :updated_by
      t.belongs_to :role
      t.belongs_to :report_for, type: :uuid
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
