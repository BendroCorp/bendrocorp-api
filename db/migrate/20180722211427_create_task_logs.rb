class CreateTaskLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :task_logs do |t|
      t.text :task_id
      t.text :task_title
      t.text :message
      t.boolean :task_succeeded
      t.timestamps
    end
  end
end
