class CreatePageEntryRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :page_entry_roles, id: :uuid do |t|
      t.belongs_to :page, type: :uuid
      t.belongs_to :role
      t.timestamps
    end
  end
end
