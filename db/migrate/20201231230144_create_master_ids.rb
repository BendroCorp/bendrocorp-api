class CreateMasterIds < ActiveRecord::Migration[5.1]
  def change
    create_table :master_ids, id: :uuid do |t|
      t.belongs_to :type, type: :uuid
      t.belongs_to :update_role
      t.timestamps
    end
  end
end
