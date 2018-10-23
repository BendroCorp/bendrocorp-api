class CreateClassificationLevelRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :classification_level_roles do |t|
      t.belongs_to :classification_level
      t.belongs_to :role
      t.timestamps
    end
  end
end
