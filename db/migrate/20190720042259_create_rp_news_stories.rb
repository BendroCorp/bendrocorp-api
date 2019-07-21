class CreateRpNewsStories < ActiveRecord::Migration[5.1]
  def change
    create_table :rp_news_stories do |t|
      t.text :title
      t.text :text
      t.belongs_to :created_by
      t.belongs_to :updated_by
      t.boolean :archived, default: false
      t.boolean :public, default: false
      t.timestamps
    end
  end
end
