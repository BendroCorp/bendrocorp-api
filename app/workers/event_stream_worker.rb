class EventStreamWorker
  include Sidekiq::Worker

  def perform(event_type, event_action, event_message)
    ActionCable.server.broadcast('event', event: { action: event_action, type: "type##{event_type}", message: event_message })
  end
end
