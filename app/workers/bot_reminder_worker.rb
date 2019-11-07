class BotReminderWorker
  include Sidekiq::Worker

  def perform(*args)
    BotReminder.where(completed: false).each do |reminder|
      if !reminder.is_expired
        # break if its not time for this one yet
        break unless reminder.last_notification < Time.now + reminder.recur_every.minutes
        # if it time then send the message
        EventStreamWorker.perform_async('reminder', { reminder: reminder.as_json })
      else
        reminder.completed = true
        reminder.save
      end     
    end
  end
end
