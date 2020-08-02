class CreatePageInCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :page_in_categories, id: :uuid do |t|
      t.belongs_to :page, type: :uuid
      t.belongs_to :category, type: :uuid
      t.timestamps
    end
  end
end
