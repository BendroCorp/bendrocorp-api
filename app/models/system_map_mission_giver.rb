class SingleParentValidator < ActiveModel::Validator
  def validate(record)
    parent_count = 0

    parent_count += 1 if record.on_system_object
    parent_count += 1 if record.on_settlement
    parent_count += 1 if record.on_location

    record.errors[:base] << 'The mission giver must belong to one and only one object!' if parent_count != 1
  end
end

class SystemMapMissionGiver < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  validates_with SingleParentValidator

  validates :discovered_by_id, presence: true
  belongs_to :discovered_by, class_name: 'User', foreign_key: 'discovered_by_id', optional: true

  belongs_to :primary_image, class_name: 'SystemMapImage', foreign_key: 'primary_image_id', optional: true

  belongs_to :on_system_object, class_name: 'SystemMapSystemObject', foreign_key: 'on_system_object_id', optional: true
  belongs_to :on_settlement, class_name: 'SystemMapSystemSettlement', foreign_key: 'on_settlement_id', optional: true
  belongs_to :on_location, class_name: 'SystemMapSystemPlanetaryBodyLocation', foreign_key: 'on_location_id', optional: true

  belongs_to :faction_affiliation, optional: true

  has_many :system_map_images, class_name: 'SystemMapImage', foreign_key: 'of_mission_giver_id'

  # include object
  # mission_givers: { methods: [:primary_image_url, :primary_image_url_full] }, 

  def parent
    # TODO: Add validation to ensure that there is only one kind of parent
    # figure out what kind of parent it has
    par = on_system_object
    par ||= on_settlement
    par ||= on_location

    # return the parent object
    par
  end

  def kind
    "Mission Giver"
  end

  def title_with_kind
    "#{self.title} (Mission Giver)"
  end

  def primary_image_url
    if self.primary_image != nil
      self.primary_image.image_url_thumbnail
    else
      # if this is null its need to be corrected
      self.primary_image = SystemMapImage.new
      self.save
      self.primary_image.image_url_thumbnail
    end
  end

  def primary_image_url_full
    self.primary_image.image_url if self.primary_image
  end

  # private
  # def validate_single_parent
  #   parent_count = 0

  #   parent_count += 1 if on_system_object
  #   parent_count += 1 if on_settlement
  #   parent_count += 1 if on_location

  #   record.errors[:base] << 'The mission giver must belong to one and only one object!' if parent_count != 1
  # end
end
