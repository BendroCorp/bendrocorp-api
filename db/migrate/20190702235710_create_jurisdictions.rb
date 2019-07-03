class CreateJurisdictions < ActiveRecord::Migration[5.1]
  def change
    create_table :jurisdictions do |t|
      t.text :title
      t.boolean :archived, default: false

      t.belongs_to :created_by
      t.timestamps
    end
  end
end
