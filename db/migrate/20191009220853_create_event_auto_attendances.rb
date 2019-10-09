class CreateEventAutoAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :event_auto_attendances, id: :uuid do |t|

      t.timestamps
    end
  end
end
