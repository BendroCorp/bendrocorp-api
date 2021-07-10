class CreateIntelligenceCases < ActiveRecord::Migration[6.1]
  def change
    create_table :intelligence_cases, id: :uuid do |t|
      t.text :title # may not use this
      t.text :case_summary
      t.text :rsi_handle
      t.text :rsi_avatar_link
      t.text :rsi_org_avatar_link
      t.text :tags
      t.belongs_to :last_seen, foreign_key: { to_table: :system_map_star_objects }, type: :uuid
      t.boolean :show_in_safe, default: false
      t.belongs_to :threat_level, foreign_key: { to_table: :field_descriptors }, type: :uuid, default: 'cfa4b341-dc8d-498d-b68f-3db2482ce66c'
      t.belongs_to :classification_level, null: false, foreign_key: true, default: 2 # internal is default

      t.belongs_to :created_by, null: false, foreign_key: { to_table: :users }
      t.belongs_to :assigned_to, foreign_key: { to_table: :users }
      t.belongs_to :assigned_by, foreign_key: { to_table: :users }

      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
