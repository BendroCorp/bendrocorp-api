class CreateAttendences < ActiveRecord::Migration[5.1]
  def change
    create_table :attendences do |t|
      t.references :attendence_type
      t.boolean :certified, default: false
      t.references :user
      t.belongs_to :character, index: true
      t.belongs_to :event, index: true
      t.timestamps
    end
  end
end
