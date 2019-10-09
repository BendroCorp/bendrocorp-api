class EventStreamWorker
  include Sidekiq::Worker

  def perform(type: 'default', message: 'None', object: {})
    ActionCable.server.broadcast('event', { type: "type##{type}", message: message, object: object })
  end
end
