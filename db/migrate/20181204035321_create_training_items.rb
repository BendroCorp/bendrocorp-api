class CreateTrainingItems < ActiveRecord::Migration[5.1]
  def change
    create_table :training_items do |t|
      t.belongs_to :training_course
      t.belongs_to :training_item_type
      t.belongs_to :created_by
      t.text :title
      t.text :text
      t.text :link
      t.text :video_link
      t.boolean :archived, default: false
      t.integer :version
      t.integer :ordinal
      t.timestamps
    end
  end
end
