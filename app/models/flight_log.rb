class FlightLog < ApplicationRecord
  belongs_to :owned_ship, :class_name => 'OwnedShip', :foreign_key => 'owned_ship_id', optional: true
  belongs_to :system, :class_name => 'SystemMapSystem', :foreign_key => 'system_id', optional: true
  belongs_to :moon, :class_name => 'SystemMapSystemPlanetaryBodyMoon', :foreign_key => 'moon_id', optional: true
  belongs_to :planet, :class_name => 'SystemMapSystemPlanetaryBody', :foreign_key => 'planet_id', optional: true
  belongs_to :system_object, :class_name => 'SystemMapSystemObject', :foreign_key => 'system_object_id', optional: true
  belongs_to :settlement, :class_name => 'SystemMapSystemSettlement', :foreign_key => 'settlement_id', optional: true
  belongs_to :location, :class_name => 'SystemMapSystemPlanetaryBodyLocation', :foreign_key => 'location_id', optional: true
  belongs_to :offender_report, :class_name => 'OffenderReport', :foreign_key => 'offender_report_id', optional: true
  belongs_to :trade_calculation, :class_name => 'TradeCalculation', :foreign_key => 'trade_calculation_id', optional: true
  belongs_to :log_owner, :class_name => 'Character', :foreign_key => 'log_owner_id'

  has_many :flight_log_images
  has_many :image_uploads, through: :flight_log_images

  accepts_nested_attributes_for :image_uploads

  def log_title
    "#{self.text[0..20]}..."
  end

  def full_location
    ret = ""
    if self.system_id != nil
      ret = "#{self.system.title}"
      if self.planet_id != nil
        ret = ret + ", #{self.planet.title}"
      end
      if self.moon_id != nil
        ret = ret + ", #{self.planet.moon}"
      end
    else
      ret = "???"
    end

    return ret
  end

  def log_writer
    self.log_owner.full_name
  end

  def log_time_ms
    self.created_at.to_f * 1000
  end
end
