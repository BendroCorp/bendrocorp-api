class IntelligenceWarrant < ApplicationRecord
  has_paper_trail

  validates :description, presence: true, length: { minimum: 50 }

  belongs_to :intelligence_case
  belongs_to :warrant_status

  def approval_completion
    self.warrant_status_id = 'e0ea84e0-4a8f-4a57-9d76-18ea97b284e9'
    # TODO: queue job to send notification to security members
    self.save
  end

  def approval_denied
    self.warrant_status_id = '513d9c85-d92d-49c0-804f-47cb091eeb95'
    self.save
  end
end
