class CreateEventCertificationRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :event_certification_requests do |t|
      t.belongs_to :event
      t.belongs_to :approval
      t.belongs_to :user
      t.timestamps
    end
  end
end
