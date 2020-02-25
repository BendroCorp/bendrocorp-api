class Event < ActiveRecord::Base
  before_create { self.briefing = EventBriefing.new }
  before_create { self.debriefing = EventDebriefing.new }

  validates :name, presence: true, length: { minimum:3, maximum: 255 }
  validates :description, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  has_many :attendences
  has_many :characters, through: :attendences
  belongs_to :event_type
  belongs_to :event_certification_request, optional: true
  has_one :briefing, :class_name => 'EventBriefing'#, :foreign_key => 'briefing_id'
  has_one :debriefing, :class_name => 'EventDebriefing'#, :foreign_key => 'debriefing_id'

  #awards
  has_many :event_awards
  has_many :awards, through: :event_awards

  has_one :event_auto_attendance

  accepts_nested_attributes_for :event_awards
  accepts_nested_attributes_for :briefing
  accepts_nested_attributes_for :debriefing
  accepts_nested_attributes_for :attendences
  accepts_nested_attributes_for :awards
  accepts_nested_attributes_for :event_auto_attendance

  def is_user_attending user_id = nil
    #useId = 0
    #if user_id != nil
    #  useId = current_user.id
    #else
    #  useId = user_id
    #end
    useId = user_id

    a = Attendence.where('user_id = ? AND event_id = ?', useId, self.id).take(1).first
    if a != nil
      a.attendence_type_id
    else
      3
    end
  end

  def event_start_rsi
      self.start_date + 930.years
  end

  def event_end_rsi
      self.end_date + 930.years
  end

  def start_date_ms
    self.start_date.to_f * 1000
  end

  def end_date_ms
    self.end_date.to_f * 1000
  end

  def rsi_start_date_ms
    event_start_rsi.to_f * 1000
  end

  def rsi_end_date_ms
    event_end_rsi.to_f * 1000
  end

  def is_expired
    self.end_date < Time.now
  end

  def url_title_string
    "#{self.name.downcase.gsub(' ', '-')}-#{self.id}"
  end

  def title_with_date
    "#{name} - #{start_date.strftime("%B, %d %YT %H%M (UTC)")}"
  end
end
