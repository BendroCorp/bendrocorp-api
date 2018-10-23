class CreateEventBriefings < ActiveRecord::Migration[5.1]
  def change
    create_table :event_briefings do |t|
      t.belongs_to :operational_leader
      t.belongs_to :reporting_designee
      t.belongs_to :communications_designee
      t.belongs_to :escort_leader

      t.text :objective
      t.text :notes

      t.belongs_to :starting_system
      t.belongs_to :ending_system

      t.boolean :published, default: false
      t.datetime :published_when

      t.belongs_to :event
      t.timestamps
    end
  end
end
