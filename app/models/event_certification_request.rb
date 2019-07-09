class EventCertificationRequest < ApplicationRecord
  belongs_to :event
  belongs_to :approval
  belongs_to :user, optional: true

  validates :event, presence: true
  validates :approval, presence: true
  validates :user_id, presence: true

  accepts_nested_attributes_for :approval
  accepts_nested_attributes_for :event

  def approval_completion #required function for request approval
    #need to actually do something here :)
    self.event.attendences.each do |attend|
      if attend.attendence_type_id == 1 # aka they attended
        PointTransaction.create(user_id: attend.character.user.id, amount: 1, reason: "Certified as attending: #{self.event.name}.", approved: true)
        self.event.awards.each do |award_it|
          if attend.character.awards.find_by_id(award_it.id) == nil || award_it.multiple_awards_allowed
            PointTransaction.create(user_id: attend.character.user.id, amount: award_it.points, approved: true, reason: "Certified as attending: #{self.event.name} and recieved award #{award_it.name}.")
            AwardsAwarded.create(character_id: attend.character.id, award_id: award_it.id, citation: "Awarded for particpation in the event: #{self.event.name}")
            # TODO: Eventually email user when they get an award
          end
        end
        attend.certified = true
      else
        #they didn't attend but we want to certify it
        attend.certified = true
      end
      self.save
    end

    # Check to make sure all of attendences are marked certified
    if self.event.attendences.where("certified = ?", false).count == 0
      self.event.certified = true
      self.event.submitted_for_certification = true
      self.save
    else
      raise 'Error occurred during event approval completion. All attendences could not be certified.'
    end

    # check to see if this event is suppose to recur
    if self.event.weekly_recurrence || self.event.monthly_recurrence
      @event = Event.new
      @event.name = self.event.name
      @event.description = self.event.description
      @event.weekly_recurrence = self.event.weekly_recurrence
      @event.monthly_recurrence = self.event.monthly_recurrence
      @event.event_type_id = self.event.event_type_id
      @event.livestream_url = self.event.livestream_url

      @event.start_date = self.event.start_date + 7.days if self.event.weekly_recurrence
      @event.end_date = self.event.end_date + 7.days if self.event.weekly_recurrence

      @event.start_date = self.event.start_date + 4.weeks if self.event.monthly_recurrence
      @event.end_date = self.event.end_date + 4.weeks if self.event.monthly_recurrence

      @event.briefing = EventBriefing.new
      @event.debriefing = EventDebriefing.new

      self.event.event_awards.each do |event_award|
        @event.event_awards << EventAward.new(award_id: event_award.award_id)
      end

      if !@event.save
        throw "ERROR Occured: Reccurring event could not be saved."
      end
    end
  end

  def approval_denied
    event = self.event
    event.submitted_for_certification = false
    event.certified = false
    event.event_certification_request_id = nil # nil this out so we keep the request and the approval
    event.save
  end
end
