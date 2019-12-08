class SystemMapSystemPlanetaryBody < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  
  validates :orbits_system_id, presence: true
  belongs_to :orbits_system, class_name: 'SystemMapSystem', foreign_key: 'orbits_system_id', optional: true

  has_many :moons, :dependent => :delete_all, class_name: 'SystemMapSystemPlanetaryBodyMoon', foreign_key: 'orbits_planet_id'

  has_many :system_objects, :dependent => :delete_all, class_name: 'SystemMapSystemObject', foreign_key: 'orbits_planet_id'

  has_many :planet_type_ins, :dependent => :delete_all, class_name: 'SystemMapSystemPlanetaryBodyTypeIn', foreign_key: 'planet_id'
  has_many :planet_types, through: :planet_type_ins, class_name: 'SystemMapSystemPlanetaryBodyType', foreign_key: 'planet_type_id'


  belongs_to :safety_rating, :class_name  => 'SystemMapSystemSafetyRating', foreign_key: 'safety_rating_id', optional: true
  belongs_to :faction_affiliation, :class_name  => 'FactionAffiliation', foreign_key: 'faction_affiliation_id', optional: true

  validates :discovered_by_id, presence: true
  belongs_to :discovered_by, class_name: 'User', foreign_key: 'discovered_by_id', optional: true

  has_many :settlements, class_name: 'SystemMapSystemSettlement', foreign_key: 'on_planet_id'

  has_many :locations, :dependent => :delete_all, class_name: 'SystemMapSystemPlanetaryBodyLocation', foreign_key: 'on_planet_id'

  has_many :system_map_images, class_name: 'SystemMapImage', foreign_key: 'of_planet_id'
  has_many :observations, class_name: 'SystemMapObservation', foreign_key: 'of_planet_id'

  has_many :flora, class_name: 'SystemMapFlora', foreign_key: 'on_planet_id'
  has_many :fauna, class_name: 'SystemMapFauna', foreign_key: 'on_planet_id'

  has_many :atmo_compositions, class_name: 'SystemMapAtmoComposition', foreign_key: 'for_planet_id'
  has_many :atmo_gases, through: :atmo_compositions, class_name: 'SystemMapAtmoGase', foreign_key: 'atmo_gas_id'

  belongs_to :jurisdiction, optional: true

  belongs_to :primary_image, class_name: 'SystemMapImage', foreign_key: 'primary_image_id', optional: true

  has_many :mission_givers, class_name: 'SystemMapMissionGiver', foreign_key: 'on_planet_id'

  def parent
    orbits_system
  end

  def kind
    'Planet'
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
    "#{self.title} (Planet)"
  end

  def title_with_system
    "#{self.title} (#{self.orbits_system.title})"
  end

  accepts_nested_attributes_for :primary_image
  accepts_nested_attributes_for :planet_type_ins
  accepts_nested_attributes_for :planet_types
  accepts_nested_attributes_for :moons
  accepts_nested_attributes_for :system_objects
  accepts_nested_attributes_for :system_map_images
  accepts_nested_attributes_for :observations
end
