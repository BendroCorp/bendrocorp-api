class CreateOffenderBounties < ActiveRecord::Migration[5.1]
  def change
    create_table :offender_bounties do |t|
      t.integer :reward
      t.text :reason

      #rsi stuff
      t.boolean :bounty_on_rsi
      t.text :rsi_bounty_link

      #statuses
      t.boolean :bounty_completed
      t.boolean :active, default: true

      t.belongs_to :offender_bounty_approval_request
      t.belongs_to :offender
      t.timestamps
    end
  end
end
