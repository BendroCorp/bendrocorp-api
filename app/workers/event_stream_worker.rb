class EventStreamWorker
  include Sidekiq::Worker

  # Emits an event over ActionCable
  def perform(type = 'default', object = {})
    ActionCable.server.broadcast('event', { type: "type##{type}", object: object })
  end
end
