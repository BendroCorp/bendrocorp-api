class SystemMapMissionGiver < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

  belongs_to :on_moon, :class_name => 'SystemMapSystemPlanetaryBodyMoon', :foreign_key => 'on_moon_id', optional: true
  belongs_to :on_planet, :class_name => 'SystemMapSystemPlanetaryBody', :foreign_key => 'on_planet_id', optional: true
  belongs_to :on_system_object, :class_name => 'SystemMapSystemObject', :foreign_key => 'on_system_object_id', optional: true
  belongs_to :on_settlement, :class_name => 'SystemMapSystemSettlement', :foreign_key => 'on_settlement_id', optional: true
  belongs_to :on_location, :class_name => 'SystemMapSystemPlanetaryBodyLocation', :foreign_key => 'on_location_id', optional: true
end
