class CreateAwardRequest < ApplicationRecord
  belongs_to :award
  belongs_to :approval
  belongs_to :user

  def approval_completion

  end

  def approval_denied

  end
end
