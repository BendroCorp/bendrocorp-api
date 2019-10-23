class DormantDiscordCompletionWorker
  include Sidekiq::Worker

  def perform(*args)
    # if a request is still hanging out the bot may have missed it. So just repeat the event
    DiscordIdentity.where(joined: false).each do |dit|
      # repeat/send the join event for that Discord identity so the bot picks it up again
      EventStreamWorker.perform_async('discord-join', { access_token: dit.access_token, nickname: discord_identity.user.main_character.full_name, identity: discord_identity.as_json })
    end
  end
end
