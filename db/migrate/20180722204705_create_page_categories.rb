class CreatePageCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :page_categories do |t|
      t.text :title
      t.timestamps null: false
      t.timestamps
    end
  end
end
