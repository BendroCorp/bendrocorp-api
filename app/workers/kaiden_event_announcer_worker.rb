require 'httparty'

class KaidenEventAnnouncerWorker
  include Sidekiq::Worker

  def perform(*args)
    Event.where(published: true, published_discord: false).each do |event|
      discordUri = ENV["WEBHOOK_LINK"]
      content = "@everyone A new operation has been posted to the Employee Portal! You can get more information here: https://my.bendrocorp.com/events/#{event.id}"
      result = HTTParty.post(discordUri,
        :body => { :content => content}.to_json, :headers => { 'Content-Type' => 'application/json' } )
      if result.code == 204
        event.published_discord = true
        event.save!
      end
    end
  end
end
