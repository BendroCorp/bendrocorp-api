class DonationItemGoalWarningWorker
  include Sidekiq::Worker

  def perform(*args)
    # loop through all of the donation items
    DonationItem.all.each do |item|
      # look for ones which are not completed which have a goal date
      if !item.is_completed && item.goal_date
        # if the current time is within 3 days of the goal date and we are not past the goal date
        if Time.now > item.goal_date - 3.days && Time.now < item.goal_date
          # emit the event so the Discord bot can handle the event
          EventStreamWorker.perform_async('donation-goal', { donation_item: item })
        end
      end
    end
  end
end
