class CreatePageCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :page_categories, id: :uuid do |t|
      t.text :title, type: :uuid
      t.boolean :featured, default: false
      t.boolean :read_only, default: false
      t.timestamps
    end
  end
end
