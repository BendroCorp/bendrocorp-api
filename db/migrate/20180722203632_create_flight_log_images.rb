class CreateFlightLogImages < ActiveRecord::Migration[5.1]
  def change
    create_table :flight_log_images do |t|
      t.belongs_to :image_upload
      t.belongs_to :flight_log
      t.timestamps
    end
  end
end
