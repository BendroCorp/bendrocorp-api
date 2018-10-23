class CreateFactionAffiliations < ActiveRecord::Migration[5.1]
  def change
    create_table :faction_affiliations do |t|
      t.text :title
      t.text :description
      t.text :icon
      t.timestamps
    end
  end
end
