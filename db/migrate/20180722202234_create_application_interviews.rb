class CreateApplicationInterviews < ActiveRecord::Migration[5.1]
  def change
    create_table :application_interviews do |t|
      t.text :tell_us_about_yourself
      t.boolean :applicant_has_read_soc
      t.boolean :applicant_agrees_to_respect_for_leadership
      t.boolean :applicant_agrees_to_voice_policy
      t.boolean :applicant_agrees_to_roleplay_style
      t.boolean :applicant_agrees_to_follow_all_policies
      t.boolean :applicant_agrees_to_understands_participation
      t.text :why_selected_division
      t.text :why_join_bendrocorp
      t.text :applicant_questions
      t.text :other_questions
      t.text :interview_consensous
      t.boolean :locked_for_review, default:false
      t.belongs_to :application
      t.timestamps
    end
  end
end
