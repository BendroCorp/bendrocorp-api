class CreateTrainingItemCompletions < ActiveRecord::Migration[5.1]
  def change
    create_table :training_item_completions do |t|
      t.belongs_to :user
      t.belongs_to :training_item
      t.integer :item_version
      t.boolean :completed, default: false
      t.timestamps
    end

    add_index :training_item_completions, :training_item_id, name: "completion_to_training_item"
  end
end
