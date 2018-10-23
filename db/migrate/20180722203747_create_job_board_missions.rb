class CreateJobBoardMissions < ActiveRecord::Migration[5.1]
  def change
    create_table :job_board_missions do |t|
      t.text :title
      t.text :description
      t.belongs_to :created_by #user
      t.belongs_to :updated_by #user
      t.belongs_to :completion_criteria #fk - also determines type of mission

      t.datetime :expires_when #controls when it should expire from job board - user determined
      t.datetime :starts_when # can be null, an escort mission may be at a specific time

      t.integer :max_acceptors, default: 1 #maximum number of members who can accept a mission
      t.datetime :accepted_when
      t.datetime :acceptence_expires_when #acceptance expires 72 hours after taking mission
      t.integer :max_completion_hours, default: 72

      t.belongs_to :creation_request
      t.belongs_to :completion_request
      t.integer :op_value, default: 2

      t.belongs_to :mission_status

      t.belongs_to :division_restriction

      # system map stuff system planet moon system_object location
      t.belongs_to :system
      t.belongs_to :moon
      t.belongs_to :planet
      t.belongs_to :system_object
      t.belongs_to :settlement
      t.belongs_to :location

      t.boolean :duplicated_in_spectrum #(bool not-in-use) - important if a mission type is/needs to be replicated in game
      t.boolean :posting_approved, default: true #set by request otherwise default is 1
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
