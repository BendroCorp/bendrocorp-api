class CreateEventAutoAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :event_auto_attendances, id: :uuid do |t|
      t.belongs_to :event
      t.belongs_to :user
      t.boolean :processed, default: false
      t.timestamps
    end
  end
end
