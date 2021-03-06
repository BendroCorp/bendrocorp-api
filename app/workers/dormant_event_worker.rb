class DormantEventWorker
  include Sidekiq::Worker

  def perform(*args)
    # find all of the eligible events
    dormant_events = Event.where('end_date > ? AND start_date < ? AND submitted_for_certification = ?', Time.now + 2.days, Time.now, false)

    # check to see if there actually are any
    if dormant_events.count > 0
      puts "Found #{dormant_events.count} dormant event(s)!"
      # generate the notification text for the dormant applications
      dormant_events_email_text = dormant_events.map { |event| "#{event.name} (For: #{((event.end_date.to_time - Time.now.to_time) / 1.hours).round} hours)" }.join('<br />')

      # get the users
      users_to_notify = Role.find_by_id(19).role_full_users.uniq
      if users_to_notify.count > 0
        # loop through the users
        users_to_notify.each do |user|
          # send individual push notifications
          dormant_events.each do |event|
            # send the push
            PushWorker.perform_async(
              user.id,
              "The event #{event.name} events are overdue for their attendance certification",
              'CALENDAR_EVENT',
              { event_id: event.id }
            )
          end

          # send email report
          # email body
          email_body = "<p>Hey #{user.main_character.first_name},</p><p>The following events are dormant and need to be submitted for certification as soon as possible:</p><p>#{dormant_events_email_text}</p>"
          # queue the email
          EmailWorker.perform_async user.email, 'Dormant Event(s)', email_body
        end

      else
        raise "DormantEventWorker could not find any users to notify!"
      end
    end
  end
end
