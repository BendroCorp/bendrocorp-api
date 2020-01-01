class CreateFactionAffiliations < ActiveRecord::Migration[5.1]
  def change
    create_table :faction_affiliations, id: :uuid do |t|
      t.text :title
      t.text :description
      t.text :color
      t.belongs_to :primary_image
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
