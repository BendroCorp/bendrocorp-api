class OffenderReportOrg < ApplicationRecord
  validates :spectrum_id, presence: true, length: { maximum: 255 }
  validates :title, presence: true, length: { maximum: 255 }

  belongs_to :violence_rating, optional: true
  has_many :known_offenders, class_name: 'OffenderReportOffender'
end
