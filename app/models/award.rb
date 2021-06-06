class Award < ActiveRecord::Base
  has_many :awards_awardeds
  has_many :characters, through: :awards_awardeds
  # has_attached_file :image,
  # #:url  => "/assets/awards/:id/:style/:basename.:extension",
  # #:path => ":rails_root/public/assets/awards/:id/:style/:basename.:extension"
  # :path => "/bendrocorp/#{Rails.env}/awards/:id/:style/:basename.:extension"

  # validates_attachment 	:image,
	# :presence => true,
	# :content_type => { :content_type => /\Aimage\/.*\Z/ },
	# :size => { :less_than => 5.megabyte }

  has_one_attached :image

  def image_url
    # self.image(:original)
  end
end
