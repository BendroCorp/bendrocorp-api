class LogChannel < ApplicationCable::Channel
  def subscribed
    stream_from "log"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    # ActionCable.server.broadcast("chat_#{params[:room]}", data)
    ActionCable.server.broadcast("log", data)
  end
end
