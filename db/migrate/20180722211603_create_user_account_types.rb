class CreateUserAccountTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :user_account_types do |t|
      t.text :title
      t.integer :ordinal
      t.timestamps
    end
  end
end
