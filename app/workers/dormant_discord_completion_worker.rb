class DormantDiscordCompletionWorker
  include Sidekiq::Worker

  def perform(*args)
    # if a request is still hanging out the bot may have missed it. So just repeat the event
    DiscordIdentity.where(joined: false).each do |dit|
      client_id = '630786822863061014'
      client_secret = ENV["DISCORD_BOT_CLIENT_SECRET"]
      # get an access token
      body_string = "client_id=#{client_id}&client_secret=#{client_secret}&grant_type=refresh_token&refresh_token=#{dit.refresh_token}&redirect_uri=https%3A%2F%2Fmy.bendrocorp.com%2Fdiscord_callback&scope=guilds.join+email+identify" if ENV["RAILS_ENV"] != nil && ENV["RAILS_ENV"] == 'production'
      body_string ||= "client_id=#{client_id}&client_secret=#{client_secret}&grant_type=refresh_token&refresh_token=#{dit.refresh_token}&redirect_uri=http%3A%2F%2Flocalhost%3A4200%2Fdiscord_callback&scope=guilds.join+email+identify"

      response = HTTParty.post('https://discordapp.com/api/v6/oauth2/token', {
        body: body_string,
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded',
          'charset' => 'utf-8'
        }
      })

      if response.code == 200
        EventStreamWorker.perform_async('discord-join', { access_token: response['access_token'], nickname: discord_identity.user.main_character.full_name, identity: discord_identity.as_json })
      else
        raise "Could not retrieve refresh_token for dit: #{dit.id} #{response.inspect}"
      end
    end
  end
end
