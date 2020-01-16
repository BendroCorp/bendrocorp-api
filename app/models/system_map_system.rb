class SystemMapSystem < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  
  has_many :gravity_wells, :class_name => 'SystemMapSystemGravityWell', :foreign_key => 'system_id'
  accepts_nested_attributes_for :gravity_wells

  has_many :planets, :class_name => 'SystemMapSystemPlanetaryBody', :foreign_key => 'orbits_system_id'

  has_many :system_objects, :class_name => 'SystemMapSystemObject', :foreign_key => 'orbits_system_id'

  validates :discovered_by_id, presence: true
  belongs_to :discovered_by, :class_name => 'User', :foreign_key => 'discovered_by_id', optional: true

  belongs_to :primary_image, class_name: 'SystemMapImage', foreign_key: 'primary_image_id', optional: true
  has_many :system_map_images, :class_name => 'SystemMapImage', :foreign_key => 'of_system_id'

  belongs_to :jurisdiction, optional: true
  belongs_to :faction_affiliation, optional: true

  belongs_to :primary_image, class_name: 'SystemMapImage', foreign_key: 'primary_image_id', optional: true

  def jump_points
    syss = SystemMapSystemConnection.where("system_one_id = ? OR system_two_id = ? ", self.id, self.id)
    ret = []

    syss.each do |sys|
      if sys.system_one_id == self.id && sys.system_two_id != self.id
        ret << { title: sys.system_one.title, id: sys.system_one.id }
      else
        ret << { title: sys.system_two.title, id: sys.system_two.id }
      end
    end
    ret
  end

  def kind
    'Star System'
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
    "#{self.title} (System)"
  end

  accepts_nested_attributes_for :planets
  accepts_nested_attributes_for :gravity_wells
  accepts_nested_attributes_for :system_objects
end
