class SystemMapSystemPlanetaryBodyMoonTypeIn < ApplicationRecord
  belongs_to :moon, :class_name => 'SystemMapSystemPlanetaryBodyMoon', :foreign_key => 'moon_id', :primary_key => :id #, :primary_key => ''
  belongs_to :moon_type, :class_name => 'SystemMapSystemPlanetaryBodyMoonType', :foreign_key => 'moon_type_id', :primary_key => :id
end
