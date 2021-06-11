class SystemMapImage < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

  belongs_to :of_star_object, class_name: 'SystemMapStarObject', foreign_key: :of_star_object_id, optional: true

  # validates :of_star_object_id, presence: true
  validates :title, presence: true
  validates :created_by_id, presence: true
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by_id', optional: true

  has_attached_file :image_old, :styles => { :mini => "25x25#", :small => "50x50#", :thumbnail => "100x100#", :big => "200x200#", :original => "1920x1080>" },
                    #content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] },
                    #:url  => "/assets/avatars/:id/:style/:basename.:extension",
                    #:path => ":rails_root/public/assets/system-map/:id/:style/:basename.:extension",
                    :path => "/bendrocorp/#{Rails.env}/system-map/:id/:style/:basename.:extension",
                    :default_url => "/assets/imgs/missing-system-map.png"

	validates_attachment 	:image_old,
				:content_type => { :content_type => /\Aimage\/.*\Z/ },
				:size => { :less_than => 10.megabyte }

  has_one_attached :image
  # validates :image, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 0..10.megabytes }

  def image_url
    # self.image.url(:original)
    # rails_blob_path(image, only_path: true) if image.attached?
    image.url.sub(/\?.*/, '') if image.attached?
  end

  def image_url_thumbnail
    # self.image.url(:big) # possible perm change, temp for now
    # rails_blob_path(image.sized(:big), only_path: true) if image.attached?
    image.variant({ resize_to_fill: [100, 100] }).processed.url.sub(/\?.*/, '') if image.attached?
  end

  def image_url_big
    # NOTE may need to adjust which version this returns
    image.variant({ resize_to_fill: [200, 200] }).processed.url.sub(/\?.*/, '') if image.attached?
  end

  # DEPRECATED - only here for migrating off of Paperclip
  def paperclip_original_uri
    self.image_old.url(:original)
  end
end
