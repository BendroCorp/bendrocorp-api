class DiscordIdentityReminderWorker
  include Sidekiq::Worker

  def perform(*args)
    User.all.each do |user|
      if user.member? && !user.discord_identity #&& user.is_in_role(9) # ceo only - temporary for testing
        discord_link = "https://discordapp.com/api/oauth2/authorize?client_id=630786822863061014&redirect_uri=https%3A%2F%2Fmy.bendrocorp.com%2Fdiscord_callback&response_type=code&scope=guilds.join%20email%20identify"
        message_body = "<p>Hey #{user.main_character.first_name},</p><p>As a part of a recent overhaul to BendroCorp application suite we are now requiring members to associate their Discord accounts with BendroCorp with limited permissions. This allows us to conduct attendance automatically now and will open up more management related functions in the future. For now please link your account via this link:</p><p><a href=\"#{discord_link}\">#{discord_link}</a></p>"
        EmailWorker.perform_async(user.email, 'Discord Linking Required', message_body)
      end
    end
  end
end
