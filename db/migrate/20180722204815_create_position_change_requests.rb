class CreatePositionChangeRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :position_change_requests do |t|
      t.belongs_to :user #required field/fk
      t.belongs_to :approval #required field/fk
      t.belongs_to :job
      t.belongs_to :character
      t.timestamps
    end
  end
end
