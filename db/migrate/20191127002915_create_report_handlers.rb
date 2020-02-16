class CreateReportHandlers < ActiveRecord::Migration[5.1]
  def change
    create_table :report_handlers do |t|
      t.text :name
      t.text :for_class
      t.belongs_to :approval_kind
      t.boolean :archived, default: false
      t.integer :ordinal
      t.timestamps
    end
  end
end
