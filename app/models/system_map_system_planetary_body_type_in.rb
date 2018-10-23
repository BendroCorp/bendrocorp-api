class SystemMapSystemPlanetaryBodyTypeIn < ApplicationRecord
  belongs_to :planet, :class_name => 'SystemMapSystemPlanetaryBody', :foreign_key => 'planet_id', :primary_key => :id #, :primary_key => ''
  belongs_to :planet_type, :class_name => 'SystemMapSystemPlanetaryBodyType', :foreign_key => 'planet_type_id', :primary_key => :id

  accepts_nested_attributes_for :planet_type
  accepts_nested_attributes_for :planet
end
