class VoiceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "voice"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def message_relay(data)
    ActionCable.server.broadcast("voice", data)
  end
end
