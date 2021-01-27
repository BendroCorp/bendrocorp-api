class FieldValue < ApplicationRecord
  has_paper_trail # auditing changes

  belongs_to :field, optional: true
  belongs_to :master, class_name: 'MasterId', optional: true

  validates :field_id, presence: true
  validates :master_id, presence: true
  # NOTE: It may seem goofy but we need to allow blank values
  # validates :value, presence: true
end
