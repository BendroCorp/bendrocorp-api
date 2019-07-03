class CreateJurisdictionLaws < ActiveRecord::Migration[5.1]
  def change
    create_table :jurisdiction_laws do |t|
      t.text :title
      t.integer :law_class # felony, misdemeanor
      t.float :fine_amount
      t.boolean :archived, default: false

      t.belongs_to :jurisdiction
      t.belongs_to :law_category

      t.belongs_to :created_by
      t.timestamps
    end
  end
end
