require 'httparty'
require 'sidekiq-scheduler'

class KaidenEventAnnouncerWorker
  include Sidekiq::Worker

  def perform(*args)
    Event.where(published: true, published_discord: false).each do |event|
      discord_uri = Rails.application.credentials[:discord][:news_webhook_link] # general 
      discord_news_uri = Rails.application.credentials[:discord][:webhook_link] # spectrum-news

      # push to members
      User.all.each do |user|
        # only members
        next unless user.isinrole(0)

        # send the push
        PushWorker.perform_async(
          user.id,
          "A new event #{event.name} has been posted on BendroCorp!",
          'NEW_CALENDAR_EVENT',
          { event_id: event.id }
        )
      end

      # content to post
      content = "@everyone A new event has been posted to the BendroCorp app! You can get more information here: https://bendrocorp.app/events/#{event.id}"

      # send to both hooks
      result = HTTParty.post(discord_uri,
        :body => { :content => content}.to_json, :headers => { 'Content-Type' => 'application/json' } )

      # send to both hooks
      result_two = HTTParty.post(discord_news_uri,
        :body => { :content => content}.to_json, :headers => { 'Content-Type' => 'application/json' } )
      if result.code == 204 && result_two.code == 204
        event.published_discord = true
        event.save!
      end
    end
  end
end
