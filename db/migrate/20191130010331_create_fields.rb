class CreateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :fields, id: :uuid do |t|
      t.text :name
      t.boolean :read_only, default: false
      t.timestamps
    end
  end
end
