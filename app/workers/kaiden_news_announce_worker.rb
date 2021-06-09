require 'httparty'
require 'sidekiq-scheduler'

class KadenNewsAnnounceWorker
  include Sidekiq::Worker

  def perform(*args)
    RpNewsStory.where(published: true, kaiden_announced: false).each do |story|
      discord_news_uri = Rails.application.credentials[:discord][:news_webhook_link] # spectrum-news
      if discord_news_uri
        # content to post
        content = "@everyone A new spectrum news article has been published: #{story.title}! Read it here: https://my.bendrocorp.com/news/#{story.id}"
        push_content = "A new spectrum news article has been published: #{story.title}!"

        # push to members
        User.all.each do |user|
          # only members
          next unless user.isinrole(0)

          # send the push
          PushWorker.perform_async(
            user.id,
            push_content,
            'VIEW_ARTICLE',
            { article_id: story.id }
          )
        end

        # send to both hooks
        result = HTTParty.post(discord_news_uri,
          body: { content: content }.to_json, headers: { 'Content-Type' => 'application/json' } )
        if result.code == 204
          story.kaiden_announced = true
          story.save!
        end
      end
    end
  end
end
