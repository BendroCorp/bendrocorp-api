class SystemMapSystemPlanetaryBodyLocation < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  
  belongs_to :location_type, class_name: 'FieldDescriptor', foreign_key: 'location_type_id', optional: true

  belongs_to :on_moon, class_name: 'SystemMapSystemPlanetaryBodyMoon', foreign_key: 'on_moon_id', optional: true
  belongs_to :on_planet, class_name: 'SystemMapSystemPlanetaryBody', foreign_key: 'on_planet_id', optional: true
  belongs_to :on_system_object, class_name: 'SystemMapSystemObject', foreign_key: 'on_system_object_id', optional: true
  belongs_to :on_settlement, class_name: 'SystemMapSystemSettlement', foreign_key: 'on_settlement_id', optional: true

  validates :discovered_by_id, presence: true
  belongs_to :discovered_by, class_name: 'User', foreign_key: 'discovered_by_id', optional: true

  has_many :system_map_images, class_name: 'SystemMapImage', foreign_key: 'of_location_id'
  # has_many :observations, class_name: 'SystemMapObservation', foreign_key: 'of_location_id'
  belongs_to :primary_image, class_name: 'SystemMapImage', foreign_key: 'primary_image_id', optional: true

  accepts_nested_attributes_for :primary_image
  # accepts_nested_attributes_for :system_map_images

  belongs_to :faction_affiliation, :class_name  => 'FactionAffiliation', foreign_key: 'faction_affiliation_id', optional: true
  has_many :mission_givers, class_name: 'SystemMapMissionGiver', foreign_key: 'on_location_id'

  def parent
    par = on_moon
    par ||= on_planet
    par ||= on_system_object
    par ||= on_settlement

    par
  end

  def kind
    "Location"
  end

  def primary_image_url
    if self.primary_image != nil
      self.primary_image.image_url_thumbnail
    else
      #if this is null its need to be corrected
      self.primary_image = SystemMapImage.new
      self.save
      self.primary_image.image_url_thumbnail
    end
  end

  def primary_image_url_full
    self.primary_image.image_url if self.primary_image
  end

  def title_with_settlement
    if self.on_settlement != nil
      "#{self.title}, #{self.on_settlement.title}"
    else
      self.title
    end
  end

  def title_with_kind
    "#{self.title} (Location)"
  end
end
