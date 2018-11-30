require 'httparty'

class KaidenAnnounceWorker
  include Sidekiq::Worker

  def perform(message)
    if ENV["WEBHOOK_LINK"]
      discordUri = ENV["WEBHOOK_LINK"]
      content = "@everyone #{message}"
      HTTParty.post(discordUri,
        :body => { :content => content}.to_json, :headers => { 'Content-Type' => 'application/json' } )
    end  
  end
end
