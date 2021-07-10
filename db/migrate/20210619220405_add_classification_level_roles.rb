class AddClassificationLevelRoles < ActiveRecord::Migration[6.1]
  def change
    ClassificationLevelRole.create([{ classification_level_id: 2, role_id: 0 },
      { classification_level_id: 3, role_id: 0 },
      { classification_level_id: 4, role_id: 0 }
    ])
  end
end
