class DormantDiscordCompletionWorker
  include Sidekiq::Worker

  def perform(*args)
    # if a request is still hanging out the bot may have missed it. So just repeat the event
    DiscordIdentity.where(joined: false).each do |dit|
      EventStreamWorker.perform_async('discord-join', { access_token: discord_access_token, nickname: db_user.main_character.full_name, identity: db_user.discord_identity.as_json })
    end
  end
end
