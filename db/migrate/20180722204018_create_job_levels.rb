class CreateJobLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :job_levels do |t|
      t.text :title
      t.integer :ordinal
      t.timestamps
    end
  end
end
