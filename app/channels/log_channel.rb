class LogChannel < ApplicationCable::Channel
  def subscribed
    stream_from "log"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
