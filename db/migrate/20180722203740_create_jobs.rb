class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.text :title
      t.text :description
      t.text :hiring_description
      t.integer :recruit_job_id
      t.integer :next_job_id
      t.belongs_to :division, index: true
      t.boolean :hiring, default: false
      t.belongs_to :job_level
      t.integer :max
      t.timestamps
    end
  end
end
