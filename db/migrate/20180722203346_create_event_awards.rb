class CreateEventAwards < ActiveRecord::Migration[5.1]
  def change
    create_table :event_awards do |t|
      t.references :award
      t.references :event
      t.timestamps
    end
  end
end
