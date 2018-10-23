class CreateApplicationComments < ActiveRecord::Migration[5.1]
  def change
    create_table :application_comments do |t|
      t.text :comment
      t.belongs_to :user, index:true
      t.belongs_to :application
      t.timestamps
    end
  end
end
