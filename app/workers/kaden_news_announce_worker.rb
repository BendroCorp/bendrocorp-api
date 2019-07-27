class KadenNewsAnnounceWorker
  include Sidekiq::Worker

  def perform(*args)
    RpNewsStory.where(published: true, kaiden_announced: false).each do |story|
      discordNewsUri = ENV["NEWS_WEBHOOK_LINK"] # spectrum-news

      # content to post
      content = "@everyone A new spectrum news article has been published! Read it here: https://my.bendrocorp.com/news/#{story.id}"
      push_contnet = "A new spectrum news article has been published!"

      # push to members
      User.all.each do |user|
        send_push_notification user.id, push_contnet if user.isinrole(0)
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
