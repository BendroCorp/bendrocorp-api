require 'httparty'
require 'sidekiq-scheduler'

class KadenNewsAnnounceWorker
  include Sidekiq::Worker

  def perform(*args)
    RpNewsStory.where(published: true, kaiden_announced: false).each do |story|
      discordNewsUri = ENV["NEWS_WEBHOOK_LINK"] # spectrum-news
      if discordNewsUri
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
            apns_category: 'VIEW_ARTICLE',
            data: { article_id: story.id }
          )
        end

        # send to both hooks
        result = HTTParty.post(discordNewsUri,
          body: { content: content }.to_json, headers: { 'Content-Type' => 'application/json' } )
        if result.code == 204
          story.kaiden_announced = true
          story.save!
        end
      end
    end
  end
end
