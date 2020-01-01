class CreateFlightLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :flight_logs do |t|
      t.text :title
      t.text :text
      t.boolean :public, default: false
      t.boolean :privacy_changes_allowed, default: true
      t.boolean :locked, default: false
      t.boolean :finalized, default: false
      t.belongs_to :owned_ship
      t.belongs_to :system, type: :uuid
      t.belongs_to :planet, type: :uuid
      t.belongs_to :moon, type: :uuid
      t.belongs_to :system_object, type: :uuid
      t.belongs_to :settlement, type: :uuid
      t.belongs_to :location, type: :uuid
      t.belongs_to :offender_report
      t.belongs_to :trade_calculation
      t.belongs_to :log_owner

      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
