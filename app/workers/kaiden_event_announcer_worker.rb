require 'httparty'
require 'sidekiq-scheduler'

class KaidenEventAnnouncerWorker
  include Sidekiq::Worker

  def perform(*args)
    Event.where(published: true, published_discord: false).each do |event|
      discordUri = ENV["WEBHOOK_LINK"] # general
      discordNewsUri = ENV["NEWS_WEBHOOK_LINK"] # spectrum-news

      # content to post
      content = "@everyone An operation and its full details have been posted to the Employee Portal! You can get more information here: https://my.bendrocorp.com/events/#{event.id}"

      # send to both hooks
      result = HTTParty.post(discordUri,
        :body => { :content => content}.to_json, :headers => { 'Content-Type' => 'application/json' } )

      # send to both hooks
      result_two = HTTParty.post(discordNewsUri,
        :body => { :content => content}.to_json, :headers => { 'Content-Type' => 'application/json' } )
      if result.code == 204 && result_two.code == 204
        event.published_discord = true
        event.save!
      end
    end
  end
end
