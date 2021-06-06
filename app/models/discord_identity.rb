require 'httparty'

class DiscordIdentity < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  belongs_to :user

  # validations
  validates :user_id, presence: true
  validates :discord_username, presence: true
  validates :discord_id, presence: true
  validates :refresh_token, presence: true

  # Retrieve an access token for the Discord Identity
  def access_token
    # client info
    client_id = Rails.application.credentials.[:discord][:bot_client_id]
    client_secret = Rails.application.credentials[:discord][:bot_client_secret]

    # get an access token w/ refresh_token
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
      # update the refresh_token - since Discord invalidates the refresh_token after its used 😁
      dit.refresh_token = response['refresh_token']
      
      if dit.save
        access_token = response['access_token']

        # return the access token
        access_token
      else
        raise "Could not save back refresh_token to identity #{dit.id} because: #{dit.errors.full_messages.to_sentence}"
      end
    else
      raise "Could not retrieve refresh_token for dit: #{dit.id}. body_string: |#{body_string}| Response: #{response.inspect}"
    end
  end
end
