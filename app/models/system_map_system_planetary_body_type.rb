class SystemMapSystemPlanetaryBodyType < ApplicationRecord
  has_many :planet_type_ins, :class_name => 'SystemMapSystemPlanetaryBodyMoonTypeIn', :foreign_key => 'planet_type_id'
  has_many :planets, through: :planet_type_ins, :class_name => 'SystemMapSystemPlanetaryBodyMoonType', :foreign_key => 'planet_id'
end
