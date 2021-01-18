class OwnedShip < ActiveRecord::Base

  validates :title, presence: true
  validates :ship_id, presence: true
  # validates :character_id, presence: true

  belongs_to :avatar, :class_name => 'ImageUpload', :foreign_key => 'avatar_id', optional: true
  belongs_to :ship
  belongs_to :character, optional: true
  belongs_to :organization_ship_request, optional: true
  has_many :crew_members, :class_name => 'OwnedShipCrew', :foreign_key => 'owned_ship_id'
  has_many :crew_roles, :class_name => 'OwnedShipCrewRole', :foreign_key => 'owned_ship_id' # OwnedShipCrewRole
  has_many :flight_logs
  #validates :title, :presence => true
  accepts_nested_attributes_for :ship
  accepts_nested_attributes_for :flight_logs
  accepts_nested_attributes_for :avatar

  before_create { self.avatar = ImageUpload.new(title: "ship avatar #{self.title}", description: "ship avatar #{self.title}", uploaded_by_id: 0) }

  def fetch_avatar
    if self.avatar != nil
      self.avatar.image_url_large
    else
      self.avatar = ImageUpload.new(title: "ship avatar #{self.title}", description: "ship avatar #{self.title}")
      self.save
    end
  end

  def user_in_crew user
    self.crew_members.each do |crew|
      return true if crew.character.id == user.main_character.id
    end
    return false
  end

  def all_flight_log_images
    ret = []
    self.flight_logs.where('public = ?', true).each do |log|
      ret << log.flight_log_images
    end
    return ret
  end

  def full_ship_title
    "#{self.title} [#{self.ship.name} (#{self.ship.manufacturer})]"
  end

  def ship_kind
    "#{self.ship.name} (#{self.ship.manufacturer})"
  end

  def ship_captain
    "#{self.character.full_name}"
  end

  def ship_title_with_captain
    "#{self.title}, #{ship_captain} commanding "
  end
end
