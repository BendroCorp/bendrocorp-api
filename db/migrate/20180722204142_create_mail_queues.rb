class CreateMailQueues < ActiveRecord::Migration[5.1]
  def change
    create_table :mail_queues do |t|

      t.timestamps
    end
  end
end
