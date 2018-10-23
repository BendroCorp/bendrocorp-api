class SystemMapSystemObjectType < ApplicationRecord
  belongs_to :system_object, :class_name => 'SystemMapSystemObject', :foreign_key => 'object_type_id'

  #belongs_to :orbits_system, :class_name => 'SystemMapSystem', :foreign_key => 'orbits_system_id'
  #belongs_to :orbits_planet, :class_name => 'SystemMapSystemPlanetaryBody', :foreign_key => 'orbits_planet_id'
  #belongs_to :orbits_moon, :class_name => 'SystemMapSystemPlanetaryBodyMoon', :foreign_key => 'orbits_moon_id'
end
