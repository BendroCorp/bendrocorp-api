require 'httparty'
require 'sidekiq-scheduler'

class KaidenEventAnnouncerWorker
  include Sidekiq::Worker

  def perform(*args)
    Event.where(published: true, published_discord: false).each do |event|
      discordUri = ENV["WEBHOOK_LINK"] # general
      discordNewsUri = ENV["NEWS_WEBHOOK_LINK"] # spectrum-news

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
