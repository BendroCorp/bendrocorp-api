class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.text :title
      t.text :subtitle
      t.text :content
      t.text :url_link
      t.text :tags
      t.boolean :read_only, default: false #if something is read_only then only an admin can update it
      t.datetime :published_when
      t.boolean :is_published, default: false
      t.belongs_to :page_category, index: true

      t.belongs_to :creator

      t.boolean :archived, default: false
      t.boolean :is_official, default: false
      t.timestamps
    end
  end
end
