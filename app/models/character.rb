class Character < ActiveRecord::Base
  has_paper_trail

  #validation_code
  validates :first_name, presence: true, length: { minimum: 3, maximum: 70 }
  validates :last_name, presence: true, length: { minimum: 3, maximum: 70 }
  validates :description, presence: true
  validates :background, presence: true
  # validates :application_id, presence: true

  # references
  belongs_to :gender, class_name: 'FieldDescriptor', foreign_key: 'gender_id', optional: true
  belongs_to :species, class_name: 'FieldDescriptor', foreign_key: 'species_id', optional: true
  belongs_to :user
  has_many :attendences, -> { where certified: true }, :dependent => :delete_all
  has_many :events, through: :attendences
  has_many :job_trackings, :dependent => :delete_all
  has_many :jobs, through: :job_trackings
  has_one :application, :dependent => :delete
  has_many :awards_awardeds, :dependent => :delete_all
  has_many :awards, through: :awards_awardeds
  has_many :owned_ships, -> { where hidden: false }, :dependent => :delete_all
  has_many :ships, through: :owned_ships

  # hr stuff
  has_many :service_notes

  has_attached_file :avatar, :styles => { :mini => "25x25#", :small => "50x50#", :thumbnail => "100x100#", :original => "200x200#" },
                    #content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] },
                    #:url  => "/assets/avatars/:id/:style/:basename.:extension",
                    #:url  => "/bendrocorp/#{Rails.env}/character/:id/:style/:basename.:extension",
                    #:path => ":rails_root/public/assets/avatars/:id/:style/:basename.:extension",
                    # :path => "/bendrocorp/#{Rails.env}/character/:id/:style/:basename.:extension",
                    :path => "/bendrocorp/#{Rails.env}/character/:id/:style/avatar-:id.:extension",
                    :default_url => "/assets/imgs/missing-avatar.png"

	validates_attachment 	:avatar,
				:content_type => { :content_type => /\Aimage\/.*\Z/ },
				:size => { :less_than => 10.megabyte }

  has_one_attached :avatar_image
  # validates :avatar, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 0..10.megabytes }

  # DEPRECATED - only here for migrating off of Paperclip
  def paperclip_original_uri
    self.avatar.url(:original).split('?')[0]
  end

  def avatar_url
    avatar.url.sub(/\?.*/, '') if avatar.attached?
  end

  def avatar_thumbnail_url
    avatar.variant({ resize: '100x100^', quality: '100%' }).processed.url.sub(/\?.*/, '') if avatar.attached?
  end

  accepts_nested_attributes_for :application
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :owned_ships, :reject_if => :reject_ships

  def reject_ships(attributed)
    attributed['title'].blank?
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def rsi_handle
    self.user.rsi_handle
  end

  def can_edit current_user
    if current_user && (current_user.admin? || (current_user.characters.find_by_id(self.id) != nil))
      return true
    else
      return false
    end
  end

  def current_job
    if self.job_trackings.count > 0
      j = self.job_trackings.order('created_at desc').first.job
      if j != nil
        j
      else
        self.job_trackings.order('created_at desc').offset(1).first.job
      end
    # else
      # this is mainly to catch any debug users. If you get this for a user something is either seriously wrong
      # or this is a debug user
      #j = Job.new(title: "No Job")
      #j.division = Division.new(name:"(Debug user?)")
      #j

    end
  end

  def is_op_eligible?
    current_job.op_eligible
  end

  def current_division
    self.current_job.division
  end

  def current_job_level
    self.current_job.job_level_id
  end

  def current_job_title
    self.current_job.title
  end
end
