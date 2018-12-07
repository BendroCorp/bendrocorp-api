class CreateApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :applications do |t|
      t.text :tell_us_about_the_real_you
      t.text :why_do_want_to_join
      t.text :how_did_you_hear_about_us
      t.references :application_interview
      t.references :application_status
      t.datetime :last_status_change
      t.references :last_status_changed_by
      t.references :job
      t.references :character
      # t.belongs_to :applicant_approval_request
      t.text :rejection_reason
      t.timestamps
    end
  end
end
