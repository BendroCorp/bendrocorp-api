class AlertAnnouncerWorker
  include Sidekiq::Worker

  def perform()
    Alert.where(published: false, approved: true, archived: false).each do |alert|
      PushWorker.perform_async(
        user.id,
        "The event #{event.name} events are overdue for their attendance certification",
        apns_category: 'CALENDAR_EVENT',
        data: { event_id: event.id }
      )

      alert.published = true
      alert.save!
    end
  end
end
