class CreateMailQueueTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :mail_queue_templates do |t|

      t.timestamps
    end
  end
end
