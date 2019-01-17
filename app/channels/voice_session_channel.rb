class VoiceSessionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "voice_session_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
