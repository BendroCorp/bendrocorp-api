class CreateTaskManagers < ActiveRecord::Migration[5.1]
  def change
    create_table :task_managers do |t|
      t.text :task_name
      t.boolean :enabled, default: true
      t.boolean :running_now, default: false
      t.datetime :last_run
      t.datetime :next_run
      t.integer :recur
      t.integer :every #minutes - 1, days - 2, weeks - 3, months - 4
      t.timestamps
    end
  end
end
