class CreateJurisdictionLawCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :jurisdiction_law_categories do |t|
      t.text :title
      t.integer :ordinal
      t.boolean :archived, default: false
      t.belongs_to :jurisdiction

      t.belongs_to :created_by
      t.timestamps
    end
  end
end
