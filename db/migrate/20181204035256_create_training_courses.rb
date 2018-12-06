class CreateTrainingCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :training_courses do |t|
      t.text :title
      t.text :description
      t.belongs_to :badge
      t.belongs_to :created_by
      t.integer :version
      t.boolean :draft, default: true
      t.boolean :approval_required, default: false
      t.boolean :instructor_required, default: false
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
