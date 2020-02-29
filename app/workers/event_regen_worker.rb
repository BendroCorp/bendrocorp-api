class EventRegenWorker
  include Sidekiq::Worker

  def perform(*args)
    Event.where('weekly_recurrence = true or monthly_recurrence = true and recurred = false').each do |old_event|
      # check to see if this event is suppose to recur
      @event = Event.new
      @event.name = old_event.name
      @event.description = old_event.description
      @event.weekly_recurrence = old_event.weekly_recurrence
      @event.monthly_recurrence = old_event.monthly_recurrence
      @event.event_type_id = old_event.event_type_id
      @event.livestream_url = old_event.livestream_url

      # if its weekly
      @event.start_date = old_event.start_date + 7.days if old_event.weekly_recurrence
      @event.end_date = old_event.end_date + 7.days if old_event.weekly_recurrence

      # if its monthly
      @event.start_date = old_event.start_date + 4.weeks if old_event.monthly_recurrence
      @event.end_date = old_event.end_date + 4.weeks if old_event.monthly_recurrence

      @event.briefing = EventBriefing.new
      @event.debriefing = EventDebriefing.new

      old_event.event_awards.each do |event_award|
        @event.event_awards << EventAward.new(award_id: event_award.award_id)
      end

      if !@event.save
        throw "ERROR Occured: Reccurring event could not be saved."
      end

      old_event.recurred = true
      if !old_event.save
        # @event.destroy
        throw "ERROR Occured: Reccurring original event could not be saved."
      end
    end
  end
end
