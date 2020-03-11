class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages, id: :uuid do |t|
      t.text :title
      t.text :subtitle
      t.text :content
      t.text :tags
      t.boolean :read_only, default: false #if something is read_only then only an admin can update it
      t.datetime :published_when
      t.boolean :published, default: false

      t.belongs_to :creator

      t.belongs_to :classification_level

      t.boolean :archived, default: false
      t.boolean :is_official, default: false
      t.timestamps
    end
  end
end
