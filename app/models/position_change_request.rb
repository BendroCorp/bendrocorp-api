class PositionChangeRequest < ApplicationRecord
  validates :user_id, presence: true
  belongs_to :user, optional: true #required field/fk
  belongs_to :approval #required field/fk
  belongs_to :job
  belongs_to :character

  accepts_nested_attributes_for :character

  def approval_completion #what happens when the approval is approved
    self.character.jobs << self.job
    self.save
  end

  def approval_denied #what happens when the approval is denied
  end
end
