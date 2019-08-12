class ImageUpload < ApplicationRecord

  # paperclip attachment
  has_attached_file :image, :styles => { :mini => "25x25#", :small => "50x50#", :thumbnail => "100x100#", :large => "200x200#" },
                    #content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] },
                    #:url  => "/assets/avatars/:id/:style/:basename.:extension",
                    #:path => ":rails_root/public/assets/avatars/:id/:style/:basename.:extension",
                    :path => "/bendrocorp/#{Rails.env}/image_uploads/:id/:style/:basename.:extension",
                    :default_url => "https://bendrocorp.com/img/avatars/missing_avatar_:style.png"
  validates :title, presence: true
	validates_attachment 	:image,
				:content_type => { :content_type => /\Aimage\/.*\Z/ }, #/\Aimage\/.*\Z/  ["image/jpeg", "image/gif", "image/png"]
				:size => { :less_than => 10.megabyte }
  #attr_accessor :image
  #attr_accessor :image_file_name

  validates :uploaded_by_id #, presence: true
  belongs_to :uploaded_by, :class_name => 'User', :foreign_key => 'uploaded_by_id', optional: true

  def image_url_mini
    self.image.url(:mini)
  end

  def image_url_small
    self.image.url(:small)
  end

  def image_url_thumbnail
    self.image.url(:thumbnail)
  end

  def image_url_large
    self.image.url(:large)
  end

  def image_url_original
    self.image.url(:original)
  end

end
