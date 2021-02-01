class CreateAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :alerts do |t|
      t.text :message
      t.integer :expire_hours
      t.datetime :expires
      t.boolean :archived

      # t.belongs_to :system
      # t.belongs_to :planet
      # t.belongs_to :moon
      # t.belongs_to :system_object
      # t.belongs_to :settlement
      # t.belongs_to :location
      t.belongs_to :alert_type
      t.belongs_to :issued_by
      t.timestamps
    end
  end
end
