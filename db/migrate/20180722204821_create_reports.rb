class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports, id: :uuid do |t|
      t.belongs_to :template, type: :uuid
      t.text :template_name
      t.text :template_description
      t.belongs_to :handler
      t.belongs_to :user
      t.belongs_to :approval
      t.belongs_to :report_for, type: :uuid
      t.boolean :draft, default: true
      t.boolean :approved, default: false
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
