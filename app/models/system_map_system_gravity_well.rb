class SystemMapSystemGravityWell < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  
  belongs_to :system, class_name: 'SystemMapSystem', foreign_key: 'system_id', optional: true
  belongs_to :gravity_well_type, class_name: 'FieldDescriptor', foreign_key: 'gravity_well_type_id', optional: true
  belongs_to :luminosity_class, class_name: 'FieldDescriptor', foreign_key: 'luminosity_class_id', optional: true

  validates :discovered_by_id, presence: true
  belongs_to :discovered_by, class_name: 'User', foreign_key: 'discovered_by_id', optional: true

  has_many :system_map_images, class_name: 'SystemMapImage', foreign_key: 'of_gravity_well_id'
  has_many :observations, class_name: 'SystemMapObservation', foreign_key: 'of_gravity_well_id'

  belongs_to :primary_image, class_name: 'SystemMapImage', foreign_key: 'primary_image_id', optional: true

  def parent
    self.system
  end

  def kind
    "Gravity Well"
  end

  def primary_image_url
    if self.primary_image != nil
      self.primary_image.image_url_big
    else
      # if this is null its need to be corrected
      self.primary_image = SystemMapImage.new
      self.save
      self.primary_image.image_url_big
    end
  end

  def primary_image_url_full
    self.primary_image.image_url if self.primary_image
  end

  accepts_nested_attributes_for :primary_image
  accepts_nested_attributes_for :system_map_images
  accepts_nested_attributes_for :observations
end
