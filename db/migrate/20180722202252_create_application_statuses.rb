class CreateApplicationStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :application_statuses do |t|
      t.text :title
      t.text :description
      t.integer :ordinal
      t.timestamps
    end
  end
end
