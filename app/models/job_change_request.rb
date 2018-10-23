class JobChangeRequest < ApplicationRecord
  belongs_to :user #required field/fk
  belongs_to :approval #required field/fk
  belongs_to :job

  def approval_completion #what happens when the approval is approved
  end

  def approval_denied #what happens when the approval is denied
  end
end
