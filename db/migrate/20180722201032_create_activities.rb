class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.text :text
      t.string :icon
      t.boolean :admin_only, default: false
      t.timestamps
    end
  end
end
