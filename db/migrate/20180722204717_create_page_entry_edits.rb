class CreatePageEntryEdits < ActiveRecord::Migration[5.1]
  def change
    create_table :page_entry_edits, id: :uuid do |t|
      t.text :comment
      t.belongs_to :page, type: :uuid
      t.belongs_to :user
      t.timestamps
    end
  end
end
