class SystemMapSystemPlanetaryBodyMoon < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

  validates :orbits_planet_id, presence: true
  belongs_to :orbits_planet, class_name: 'SystemMapSystemPlanetaryBody', foreign_key: 'orbits_planet_id', optional: true

  has_many :system_objects, :dependent => :delete_all, class_name: 'SystemMapSystemObject', foreign_key: 'orbits_moon_id'

  has_many :moon_type_ins, :dependent => :delete_all, class_name: 'SystemMapSystemPlanetaryBodyMoonTypeIn', foreign_key: 'moon_id'
  has_many :moon_types, through: :moon_type_ins, class_name: 'SystemMapSystemPlanetaryBodyMoonType', foreign_key: 'moon_type_id'

  has_many :settlements, class_name: 'SystemMapSystemSettlement', foreign_key: 'on_moon_id'
  has_many :locations, :dependent => :delete_all, class_name: 'SystemMapSystemPlanetaryBodyLocation', foreign_key: 'on_moon_id'

  validates :discovered_by_id, presence: true
  belongs_to :discovered_by, class_name: 'User', foreign_key: 'discovered_by_id', optional: true

  belongs_to :safety_rating, :class_name  => 'SystemMapSystemSafetyRating', foreign_key: 'safety_rating_id', optional: true
  belongs_to :faction_affiliation, :class_name  => 'FactionAffiliation', foreign_key: 'faction_affiliation_id', optional: true

  has_many :system_map_images, class_name: 'SystemMapImage', foreign_key: 'of_moon_id'
  has_many :observations, class_name: 'SystemMapObservation', foreign_key: 'of_moon_id'

  belongs_to :primary_image, class_name: 'SystemMapImage', foreign_key: 'primary_image_id', optional: true

  has_many :flora, class_name: 'SystemMapFlora', foreign_key: 'on_moon_id'
  has_many :fauna, class_name: 'SystemMapFauna', foreign_key: 'on_moon_id'

  has_many :atmo_compositions, class_name: 'SystemMapAtmoComposition', foreign_key: 'for_moon_id'
  has_many :atmo_gases, through: :atmo_compositions, class_name: 'SystemMapAtmoGase', foreign_key: 'atmo_gas_id'

  belongs_to :jurisdiction, optional: true

  has_many :mission_givers, class_name: 'SystemMapMissionGiver', foreign_key: 'on_moon_id'

  def parent
    orbits_planet
  end

  def kind
    'Moon'
  end

  def primary_image_url
    if self.primary_image != nil
      self.primary_image.image_url_big
    else
      #if this is null its need to be corrected
      self.primary_image = SystemMapImage.new
      self.save
      self.primary_image.image_url_big
    end
  end

  def primary_image_url_full
    self.primary_image.image_url if self.primary_image
  end

  def title_with_kind
    "#{self.title} (Moon)"
  end

  accepts_nested_attributes_for :primary_image
  accepts_nested_attributes_for :moon_type_ins
  accepts_nested_attributes_for :moon_types
  accepts_nested_attributes_for :system_objects
  accepts_nested_attributes_for :locations
  accepts_nested_attributes_for :system_map_images
  accepts_nested_attributes_for :observations
end
