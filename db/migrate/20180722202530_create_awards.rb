class CreateAwards < ActiveRecord::Migration[5.1]
  def change
    create_table :awards do |t|
      t.text :name
      t.text :description
      t.integer :points
      t.boolean :multiple_awards_allowed, default: false
      t.boolean :outofband_awards_allowed, default: true
      t.belongs_to :create_award_request
      t.timestamps
    end
  end
end
