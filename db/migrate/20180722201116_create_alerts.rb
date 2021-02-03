class CreateAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :alerts do |t|
      t.text :title
      t.text :description
      t.datetime :expires
      t.boolean :approved, default: false
      t.boolean :archived, default: false

      # t.belongs_to :system
      # t.belongs_to :planet
      # t.belongs_to :moon
      # t.belongs_to :system_object
      # t.belongs_to :settlement
      # t.belongs_to :location
      t.belongs_to :star_object
      t.belongs_to :alert_type
      t.belongs_to :user
      t.belongs_to :approval
      t.timestamps
    end
  end
end
