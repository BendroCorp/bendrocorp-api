class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel" # #{params[:room]}
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    # ActionCable.server.broadcast("chat_#{params[:room]}", data)
    ActionCable.server.broadcast("chat_channel", data)
  end
end
