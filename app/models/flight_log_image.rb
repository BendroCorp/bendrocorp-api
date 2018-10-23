class FlightLogImage < ApplicationRecord
  belongs_to :image_upload
  belongs_to :flight_log
end
