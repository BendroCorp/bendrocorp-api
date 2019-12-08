class SystemMapFauna < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

  belongs_to :on_moon, :class_name => 'SystemMapSystemPlanetaryBodyMoon', :foreign_key => 'on_moon_id'
  belongs_to :on_planet, :class_name => 'SystemMapSystemPlanetaryBody', :foreign_key => 'on_planet_id'
  belongs_to :on_system_object, :class_name => 'SystemMapSystemObject', :foreign_key => 'on_system_object_id'

  validates :discovered_by_id, presence: true
  belongs_to :discovered_by, :class_name => 'User', :foreign_key => 'discovered_by_id', optional: true

  belongs_to :primary_image, :class_name => 'SystemMapImage', :foreign_key => 'primary_image_id'

  accepts_nested_attributes_for :primary_image

  def kind
    "Fauna"
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
end
