class EventStreamWorker
  include Sidekiq::Worker

  def perform(type = 'default', object = {})
    ActionCable.server.broadcast('event', { type: "type##{type}", object: object })
  end
end
