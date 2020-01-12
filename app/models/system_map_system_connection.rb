class SystemMapSystemConnection < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

  validates :title, presence: true

  belongs_to :connection_status, class_name: 'FieldDescriptor', foreign_key: 'connection_status_id', optional: true
  belongs_to :connection_size, class_name: 'FieldDescriptor', foreign_key: 'connection_size_id', optional: true

  validates :system_one_id, presence: true
  belongs_to :system_one, class_name: 'SystemMapSystem', foreign_key: 'system_one_id', optional: true

  validates :system_two_id, presence: true
  belongs_to :system_two, class_name: 'SystemMapSystem', foreign_key: 'system_two_id', optional: true

  belongs_to :primary_image_one, class_name: 'SystemMapImage', foreign_key: 'primary_image_one_id', optional: true

  belongs_to :primary_image_two, class_name: 'SystemMapImage', foreign_key: 'primary_image_two_id', optional: true

  validates :discovered_by_id, presence: true
  belongs_to :discovered_by, class_name: 'User', foreign_key: 'discovered_by_id'

  has_many :system_map_images, class_name: 'SystemMapImage', foreign_key: 'of_connection_id'

  accepts_nested_attributes_for :primary_image_one
  accepts_nested_attributes_for :primary_image_two

  def kind
    "Jump Point"
  end

  def primary_image_one_url
    if self.primary_image_one != nil
      self.primary_image_one.image_url_thumbnail
    else
      #if this is null its need to be corrected
      self.primary_image_one = SystemMapImage.new
      self.save
      self.primary_image_one.image_url_thumbnail
    end
  end

  def primary_image_one_url_full
    self.primary_image_one.image_url if self.primary_image_one
  end

  def primary_image_two_url
    if self.primary_image_two != nil
      self.primary_image_two.image_url_thumbnail
    else
      #if this is null its need to be corrected
      self.primary_image_two = SystemMapImage.new
      self.save
      self.primary_image_two.image_url_thumbnail
    end
  end

  def primary_image_url_two_full
    self.primary_image_two.image_url if self.primary_image_two
  end
end
