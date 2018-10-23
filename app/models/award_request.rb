class AwardRequest < ApplicationRecord
  belongs_to :award
  belongs_to :approval
  belongs_to :user #the user making the request

  belongs_to :on_behalf_of, :class_name => 'Character', :foreign_key => 'on_behalf_of_id'

  accepts_nested_attributes_for :on_behalf_of

  validates :on_behalf_of, presence: true
  validates :award, presence: true

  def approval_completion
    if self.award != nil
      #check for status chagne on the award
      if (self.on_behalf_of.awards.where("awards.id = ?", self.award.id).count < 1 || self.award.multiple_awards_allowed) && self.award.outofband_awards_allowed
        self.on_behalf_of.awards << Award.find_by_id(self.award.id)
        if !self.save
          error
        end
      else
        # TODO: FLASH should not be used
        # flash[:warning] = "The request was completed but the award could not be issued because either it is no longer awardable out of band or it has already been awarded and cannot be awarded multiple times."
      end
    end
  end

  def approval_denied
    #do nothing
  end
end
