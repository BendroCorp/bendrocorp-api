class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.text :name
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :weekly_recurrence, default: false
      t.boolean :monthly_recurrence, default: false
      t.references :event_type
      t.text :livestream_url
      t.boolean :submitted_for_certification, default: false
      t.boolean :certified, default: false
      t.references :event_certification_request

      t.boolean :show_on_dashboard, default: true
      t.boolean :published, default: false
      t.datetime :published_date
      t.boolean :published_discord, default: false
      t.boolean :published_final_discord, default: false

      t.belongs_to :briefing
      t.belongs_to :debriefing
      t.belongs_to :classification_level

      t.belongs_to :archived, default: false
      t.timestamps
    end
  end
end
