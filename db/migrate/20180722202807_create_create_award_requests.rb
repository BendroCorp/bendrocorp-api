class CreateCreateAwardRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :create_award_requests do |t|
      t.belongs_to :user #required field/fk
      t.belongs_to :award
      t.belongs_to :approval #required field/fk
      t.timestamps
    end
  end
end
