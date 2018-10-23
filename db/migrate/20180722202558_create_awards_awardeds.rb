class CreateAwardsAwardeds < ActiveRecord::Migration[5.1]
  def change
    create_table :awards_awardeds do |t|
      t.text :citation
      t.belongs_to :character, index: true
      t.belongs_to :award, index: true
      t.timestamps
    end
  end
end
