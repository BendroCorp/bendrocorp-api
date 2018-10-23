class CreateMenuItems < ActiveRecord::Migration[5.1]
  def change
    create_table :menu_items do |t|
      t.text :title
      t.text :icon
      t.text :link
      t.boolean :internal, default: true # will the angular router handle this :)
      t.belongs_to :nested_under
      t.integer :ordinal
      t.timestamps
    end
  end
end
