class CreateClassificationRequestTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :classification_request_types do |t|
      t.text :title
      t.text :description
      t.text :class
      t.timestamps
    end
  end
end
