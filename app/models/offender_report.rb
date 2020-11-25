class OffenderReport < ApplicationRecord
  validates :infractions_committed, presence: true#, :length => { :minimum => 1 }

  validates :created_by_id, presence: true

  validates :description, presence: true, length: { minimum: 10 }
  validates :occured_when, presence: true

  # fks
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by_id', optional: true
  belongs_to :offender, :class_name => 'OffenderReportOffender', :foreign_key => 'offender_id', optional: true
  belongs_to :violence_rating, :class_name => 'OffenderReportViolenceRating', :foreign_key => 'violence_rating_id'
  belongs_to :ship, :class_name => 'Ship', :foreign_key => 'ship_id', optional: true
  belongs_to :system, :class_name => 'SystemMapSystem', :foreign_key => 'system_id', optional: true
  belongs_to :moon, :class_name => 'SystemMapSystemPlanetaryBodyMoon', :foreign_key => 'moon_id', optional: true
  belongs_to :planet, :class_name => 'SystemMapSystemPlanetaryBody', :foreign_key => 'planet_id', optional: true
  belongs_to :system_object, :class_name => 'SystemMapSystemObject', :foreign_key => 'system_object_id', optional: true
  belongs_to :settlement, :class_name => 'SystemMapSystemSettlement', :foreign_key => 'settlement_id', optional: true
  belongs_to :location, :class_name => 'SystemMapSystemPlanetaryBodyLocation', :foreign_key => 'location_id', optional: true

  belongs_to :offender_report_approval_request, :class_name => 'OffenderReportApprovalRequest', :foreign_key => 'offender_report_approval_request_id', optional: true

  belongs_to :classification_level, optional: true

  has_many :infractions_committed, class_name: 'OffenderReportInfractionsCommitted', foreign_key: 'report_id'
  has_many :infractions, through: :infractions_committed, class_name: 'OffenderReportInfraction', foreign_key: 'infraction_id'

  belongs_to :force_level_applied, class_name: 'OffenderReportForceLevel', foreign_key: 'force_level_applied_id'

  accepts_nested_attributes_for :offender
  accepts_nested_attributes_for :offender_report_approval_request

  def occured_when_ms
    self.created_at.to_f * 1000
  end

  def full_location
    ret = ""
    if self.system_id != nil
      ret = "#{system.title}"
      if self.planet_id != nil
        ret = ret + ", #{self.planet.title}"
      end
      if self.moon_id != nil
        ret = ret + ", #{self.moon.title}"
      end
    else
      ret = "???"
    end

    return ret
  end
end
