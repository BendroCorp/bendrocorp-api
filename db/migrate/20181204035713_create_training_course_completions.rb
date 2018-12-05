class CreateTrainingCourseCompletions < ActiveRecord::Migration[5.1]
  def change
    create_table :training_course_completions do |t|
      t.belongs_to :user
      t.belongs_to :training_course
      t.integer :version
      t.timestamps
    end
  end
end
