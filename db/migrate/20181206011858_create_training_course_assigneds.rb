class CreateTrainingCourseAssigneds < ActiveRecord::Migration[5.1]
  def change
    create_table :training_course_assigneds do |t|
      t.belongs_to :user
      t.belongs_to :training_course
      t.belongs_to :assigned_by
      t.datetime :due_date
      t.boolean :completed, default: false
      t.timestamps
    end
  end
end
