class CreateUserDeviceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :user_device_types do |t|
      t.text :title
      t.text :description
      t.timestamps
    end
  end
end
