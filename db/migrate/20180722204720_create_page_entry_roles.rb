class CreatePageEntryRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :page_entry_roles do |t|
      t.belongs_to :page
      t.belongs_to :role
      t.timestamps
    end
  end
end
