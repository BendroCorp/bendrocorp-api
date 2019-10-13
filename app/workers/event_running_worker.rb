class EventRunningWorker
  include Sidekiq::Worker

  def perform(*args)
    Event.where('start_date < ? AND end_date > ?', Time.now, Time.now).each do |event|
      # 
      EventStreamWorker.perform_async('event-running', { event: event.as_json })
    end
  end
end
