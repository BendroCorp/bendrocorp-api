class KaidenEventStartWarningWorker
  include Sidekiq::Worker

  def perform(*args)
    # There should theoretically only be one but if there multiple just let it  goes
    Event.where('start_date >= ? AND published_final_discord = ? AND published = ? AND NOT end_date < ?', Time.now - 20.minutes, false, true, Time.now).each do |event|
      if ENV["WEBHOOK_LINK"]
        discordUri = ENV["WEBHOOK_LINK"]
        content = "@everyone Hello everyone! #{event.title} is starting in #{(((event.start_date + 21.minutes).to_time - Time.now.to_time) / 1.minute).round} minutes. We look forward to seeing everyone who can come!"
        result = HTTParty.post(discordUri,
          :body => { :content => content }.to_json, :headers => { 'Content-Type' => 'application/json' } )

        if result.code == 204
          event.published_final_discord = true
          event.save!
        end
      end
    end
  end
end
