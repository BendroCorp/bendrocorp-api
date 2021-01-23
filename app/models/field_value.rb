class FieldValue < ApplicationRecord
  has_paper_trail # auditing changes

  belongs_to :field, optional: true
  belongs_to :master, optional: true

  validates :field_id, presence: true
  validates :master_id, presence: true
  validates :value, presence: true
end
