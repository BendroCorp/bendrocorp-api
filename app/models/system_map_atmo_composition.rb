class SystemMapAtmoComposition < ApplicationRecord
  belongs_to :for_planet, :class_name => 'SystemMapSystemPlanetaryBodyMoon', :foreign_key => 'for_planet_id'
  belongs_to :for_moon, :class_name => 'SystemMapSystemPlanetaryBodyMoon', :foreign_key => 'for_moon_id'
  belongs_to :for_system_object, :class_name => 'SystemMapSystemPlanetaryBodyMoon', :foreign_key => 'for_system_object_id'
  belongs_to :atmo_gas, :class_name => 'SystemMapAtmoGase', :foreign_key => 'atmo_gas_id'
end
