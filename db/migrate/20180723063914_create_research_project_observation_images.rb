class CreateResearchProjectObservationImages < ActiveRecord::Migration[5.1]
  def change
    create_table :research_project_observation_images do |t|
      t.belongs_to :research_project_observation, index: false
      t.belongs_to :image_upload
      t.timestamps
    end
    add_index :research_project_observation_images, :research_project_observation_id, name: "rp_image_to_project_obj_id"

  end
end
