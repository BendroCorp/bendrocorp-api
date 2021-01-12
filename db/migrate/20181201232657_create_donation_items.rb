class CreateDonationItems < ActiveRecord::Migration[5.1]
  def change
    create_table :donation_items do |t|
      t.text :title
      t.text :description
      t.integer :goal # dollar goal
      t.datetime :goal_date
      t.belongs_to :created_by
      t.boolean :archived, default: false
      t.integer :ordinal
      t.belongs_to :donation_type, type: :uuid
      t.timestamps
    end
  end
end
