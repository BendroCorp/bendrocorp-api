class CreateAlertTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :alert_types do |t|
      t.text :title
      t.text :sub_title
      t.text :description
      t.text :color
      t.boolean :selectable, default: false
      t.timestamps
    end
  end
end
