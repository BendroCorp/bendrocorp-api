class IntelligenceCaseComment < ApplicationRecord
  has_paper_trail

  # validations
  validates :comment, presence: true
  validates :intelligence_case_id, presence: true

  # other objects
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  belongs_to :intelligence_case

  def test
    'test'
  end
end
