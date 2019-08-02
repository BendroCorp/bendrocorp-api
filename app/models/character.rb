class Character < ActiveRecord::Base
  #validation_code
  validates :first_name, presence: true, length: { minimum:3, maximum: 70 }
  validates :last_name, presence: true, length: { minimum:3, maximum: 70 }
  validates :description, presence: true
  validates :background, presence: true
  # validates :application_id, presence: true


  #references
  belongs_to :gender, :class_name => 'CharacterGender', :foreign_key => 'gender_id', optional: true
  belongs_to :species, :class_name => 'CharacterSpecy', :foreign_key => 'species_id', optional: true
  belongs_to :user
  has_many :attendences, -> { where certified: true }
  has_many :events, through: :attendences
  has_many :job_trackings
  has_many :jobs, through: :job_trackings
  has_one :application
  has_many :awards_awardeds
  has_many :awards, through: :awards_awardeds
  has_many :owned_ships, -> { where hidden: false }
  has_many :ships, through: :owned_ships

  #hr stuff
  has_many :service_notes

  #http://josephndungu.com/tutorials/ajax-file-upload-with-dropezonejs-and-paperclip-rails
  #http://stackoverflow.com/questions/3219787/how-do-i-tell-paperclip-to-not-save-the-original-file :D
  #http://railscasts.com/episodes/134-paperclip
  #http://stackoverflow.com/questions/8876340/paperclip-resize-and-crop-to-rectangle
  has_attached_file :avatar, :styles => { :mini => "25x25#", :small => "50x50#", :thumbnail => "100x100#", :original => "200x200#" },
                    #content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] },
                    #:url  => "/assets/avatars/:id/:style/:basename.:extension",
                    #:url  => "/bendrocorp/#{Rails.env}/character/:id/:style/:basename.:extension",
                    #:path => ":rails_root/public/assets/avatars/:id/:style/:basename.:extension",
                    :path => "/bendrocorp/#{Rails.env}/character/:id/:style/:basename.:extension",
                    :default_url => "/assets/imgs/missing-avatar.png"

	validates_attachment 	:avatar,
				:content_type => { :content_type => /\Aimage\/.*\Z/ },
				:size => { :less_than => 10.megabyte }

  def avatar_url
    self.avatar.url(:original)
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
