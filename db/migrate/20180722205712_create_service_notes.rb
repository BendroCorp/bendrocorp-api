class CreateServiceNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :service_notes do |t|
      t.text :text
      t.belongs_to :character
      t.timestamps
    end
  end
end
