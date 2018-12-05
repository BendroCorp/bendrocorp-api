class CreateTrainingItemCompletions < ActiveRecord::Migration[5.1]
  def change
    create_table :training_item_completions do |t|
      t.belongs_to :user
      t.belongs_to :training_item
      t.timestamps
    end
  end
end
