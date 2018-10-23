class CreateAttendenceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :attendence_types do |t|
      t.text :title
      t.timestamps
    end
  end
end
