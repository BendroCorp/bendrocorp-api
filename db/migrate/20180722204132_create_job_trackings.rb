class CreateJobTrackings < ActiveRecord::Migration[5.1]
  def change
    create_table :job_trackings do |t|
      t.belongs_to :job, index: true
      t.belongs_to :character, index: true
      t.timestamps
    end
  end
end
