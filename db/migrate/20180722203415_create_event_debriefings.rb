class CreateEventDebriefings < ActiveRecord::Migration[5.1]
  def change
    create_table :event_debriefings do |t|
      t.text :text
      t.boolean :published, default: false
      t.boolean :published_when

      t.belongs_to :event
      t.timestamps
    end
  end
end
