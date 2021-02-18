class KaidenEventStartWarningWorker
  include Sidekiq::Worker

  def perform(*args)
    # There should theoretically only be one but if there multiple just let it  goes
    Event.where('start_date <= ? AND published_final_discord = ? AND published = ? AND NOT end_date < ?', Time.now + 20.minutes, false, true, Time.now).each do |event|
      # push to members
      User.all.each do |user|
        # only members
        next unless user.isinrole(0)

        # send the push
        PushWorker.perform_async(
          user.id,
          "The #{event.name} event is starting in #{((event.start_date.to_time - Time.now.to_time) / 1.minute).round} minutes. Looking forward to seeing you there!",
          apns_category: 'CALENDAR_EVENT',
          data: { event_id: event.id }
        )
      end

      if ENV["WEBHOOK_LINK"]
        discordUri = ENV["WEBHOOK_LINK"]
        content = "@everyone Hello everyone! #{event.name} is starting in #{((event.start_date.to_time - Time.now.to_time) / 1.minute).round} minutes. We look forward to seeing everyone who can come!"
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
