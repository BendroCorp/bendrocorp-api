class CreateAwardRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :award_requests do |t|
      t.text :citation

      t.belongs_to :on_behalf_of
      t.belongs_to :award
      t.belongs_to :approval
      t.belongs_to :user
      t.timestamps
    end
  end
end
