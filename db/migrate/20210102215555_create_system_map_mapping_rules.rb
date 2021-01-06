class CreateSystemMapMappingRules < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_mapping_rules, id: :uuid do |t|
      t.belongs_to :parent, type: :uuid
      t.belongs_to :child, type: :uuid
      t.text :note
      t.timestamps
    end
  end
end
