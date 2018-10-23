class ApplicationInterview < ApplicationRecord
  belongs_to :application, optional: true

  #before_save :is_interview_locked

  def is_interview_locked
    interview = ApplicationInterview.find_by id: self.id
    if interview != nil && interview.id != nil
      if interview.locked_for_review == true
        false #return false to stop the save
      else
        true #return true to allow the save
      end
    else
      true #allow the save because the record does not exist yet
    end
  end
end
