class CreateClassificationRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :classification_requests do |t|
      t.belongs_to :user #required field/fk
      t.belongs_to :approval #required field/fk
      t.belongs_to :classification_request_type, index: false
      t.integer :requested_item
      t.timestamps
    end
    add_index :classification_requests, :classification_request_type_id, name: "index_classification_request_to_type"
  end
end
