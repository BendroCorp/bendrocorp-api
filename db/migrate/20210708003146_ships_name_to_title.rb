class ShipsNameToTitle < ActiveRecord::Migration[6.1]
  def change
    change_table :ships do |t|
      t.rename :name, :title
    end
  end
end
