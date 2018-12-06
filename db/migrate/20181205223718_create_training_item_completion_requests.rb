class CreateTrainingItemCompletionRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :training_item_completion_requests do |t|
      t.belongs_to :user #required field/fk
      t.belongs_to :approval #required field/fk
      t.belongs_to :training_item_completion, index: false
      t.timestamps
    end

    add_index :training_item_completion_requests, :training_item_completion_id, name: "request_to_completion_training_item"
  end
end
