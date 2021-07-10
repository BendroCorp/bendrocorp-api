class CreateIncidentReports < ActiveRecord::Migration[6.1]
  def change
    create_table :incident_reports, id: :uuid do |t|
      t.text :description
      t.text :rsi_handle
      t.text :rsi_avatar_link
      t.text :rsi_org_avatar_link
      t.datetime :occured_when

      t.belongs_to :star_object, foreign_key: { to_table: :system_map_star_objects }, type: :uuid
      t.belongs_to :intelligence_case, null: false, foreign_key: true, type: :uuid
      t.belongs_to :force_used, foreign_key: { to_table: :field_descriptors }, type: :uuid
      t.belongs_to :ship_used, foreign_key: { to_table: :ships }
      t.belongs_to :threat_level, foreign_key: { to_table: :field_descriptors }, type: :uuid, default: 'cfa4b341-dc8d-498d-b68f-3db2482ce66c'
      t.belongs_to :classification_level, null: false, foreign_key: true, default: 1

      # users involved
      # t.belongs_to :disposition_by, foreign_key: { to_table: :users }
      t.belongs_to :created_by, null: false, foreign_key: { to_table: :users }

      t.belongs_to :approval_status,
      foreign_key: { to_table: :field_descriptors },
      type: :uuid,
      default: 'a067e0d6-018e-4afc-87c9-6c486c512a76'
      t.boolean :show_in_safe, default: true
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
