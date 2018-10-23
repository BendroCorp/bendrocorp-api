class CreateStoreItemCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :store_item_categories do |t|
      t.text :title
      t.text :description

      t.belongs_to :creator
      t.belongs_to :last_updated_by
      t.timestamps
    end
  end
end
