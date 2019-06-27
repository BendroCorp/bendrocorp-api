class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "appearance"
    # circle > send online > TriggerClients to send to AppearanceReplyChannel
    current_user.appear
    send_user_list
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    current_user.disappear
    send_user_list
  end

  def away
    # TODO
  end

  def send_user_list
    ActionCable.server.broadcast("appearance", User.where(is_online: true).as_json(only: [:id], methods: [:main_character_full_name, :main_character_avatar_url, :main_character_job_title]))
  end
end
