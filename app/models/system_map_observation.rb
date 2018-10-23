class SystemMapObservation < ApplicationRecord
  belongs_to :of_system, :class_name => 'SystemMapSystem', :foreign_key => 'of_system_id'
  belongs_to :of_planet, :class_name => 'SystemMapSystemPlanetaryBody', :foreign_key => 'of_planet_id'
  belongs_to :of_moon, :class_name => 'SystemMapSystemPlanetaryBodyMoon', :foreign_key => 'of_moon_id'
  belongs_to :of_gravity_well, :class_name => 'SystemMapSystemGravityWellType', :foreign_key => 'of_gravity_well_id'
  belongs_to :of_system_object, :class_name => 'SystemMapSystemObject', :foreign_key => 'of_system_object_id'
  belongs_to :of_location, :class_name => 'SystemMapSystemPlanetaryBodyLocation', :foreign_key => 'of_location_id'
end
