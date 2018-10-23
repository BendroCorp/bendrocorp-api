class SystemMapSystemPlanetaryBodyMoonType < ApplicationRecord
  has_many :moon_type_ins, :class_name => 'SystemMapSystemPlanetaryBodyMoonTypeIn', :foreign_key => 'moon_type_id'
  has_many :moons, through: :moon_type_ins, :class_name => 'SystemMapSystemPlanetaryBodyMoonType', :foreign_key => 'moon_id'
end
