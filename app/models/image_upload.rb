class ImageUpload < ApplicationRecord

  # paperclip attachment
  has_attached_file :image_old, :styles => { :mini => "25x25#", :small => "50x50#", :thumbnail => "100x100#", :large => "200x200#", :original => "1920x1080>" },
                    #content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] },
                    #:url  => "/assets/avatars/:id/:style/:basename.:extension",
                    #:path => ":rails_root/public/assets/avatars/:id/:style/:basename.:extension",
                    :path => "/bendrocorp/#{Rails.env}/image_uploads/:id/:style/:basename.:extension",
                    :default_url => "https://bendrocorp.com/img/avatars/missing_avatar_:style.png"
  validates :title, presence: true
	validates_attachment 	:image_old,
				:content_type => { :content_type => /\Aimage\/.*\Z/ }, #/\Aimage\/.*\Z/  ["image/jpeg", "image/gif", "image/png"]
				:size => { :less_than => 10.megabyte }
  #attr_accessor :image
  #attr_accessor :image_file_name

  has_one_attached :image

  # validates :uploaded_by_id , presence: true
  belongs_to :uploaded_by, class_name: 'User', foreign_key: :uploaded_by_id, optional: true

  def image_url_mini
    # self.image.url(:mini)
    image.variant({ resize_to_fill: [25, 25] }).processed.url.sub(/\?.*/, '') if image.attached?
  end

  def image_url_thumbnail
    # self.image.url(:thumbnail)
    # rails_blob_path(image.sized(:thumbnail), only_path: true) if image.attached?
    image.variant({ resize_to_fill: [100, 100] }).processed.url.sub(/\?.*/, '') if image.attached?
  end

  def image_url_original
    # self.image.url(:original)
    image.processed.url.sub(/\?.*/, '') if image.attached?
  end

  # DEPRECATED - only here for migrating off of Paperclip
  def paperclip_original_uri
    self.image_old.url(:original)
  end

  def image_url
    image_url_original
  end
end
