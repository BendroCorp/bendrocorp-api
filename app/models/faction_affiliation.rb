class FactionAffiliation < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

  HEX_CODE_REGEX = /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/

  validates :color, format: { with: HEX_CODE_REGEX }, allow_nil: true

  belongs_to :primary_image, class_name: 'ImageUpload', foreign_key: 'primary_image_id', optional: true

  def primary_image_url
    if self.primary_image != nil
      self.primary_image.image_url_large
    else
      #if this is null its need to be corrected
      self.primary_image = ImageUpload.new
      self.save
      self.primary_image.image_url_large
    end
  end

  def primary_image_url_full
    self.primary_image.image_url if self.primary_image
  end
end
