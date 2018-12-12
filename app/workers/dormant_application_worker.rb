class DormantApplicationWorker
  include Sidekiq::Worker

  def perform(*args)
    # find all of the applications with no advancement that dont have a final status
    dormant_applications = Application.where('updated_at < ? AND application_status_id < 6', Time.now + 2.days)

    # see if we actually have any
    if dormant_applications.count > 0

      # generate the notification text for the dormant applications
      dormation_applications_text = ""
      dormant_applications.each do |app|
        dormation_applications_text = "#{dormation_applications_text} #{app.character.full_name} (#{((app.updated_at.to_time - Time.now.to_time) / 1.hours).round} hours)</br>"
      end

      # get the users
      users_to_notify = Role.where('id IN (2,7)').map { |r| r.role_full_users }.flatten.uniq
      if users_to_notify.count > 0

        # loop through the users
        users_to_notify.each do |user|
          # body
          email_body = "<p>Hey #{user.main_character.first_name},</p><p>The following membership application(s) are stagnate and need to be addressed:</p><p>#{dormation_applications_text}</p><p>It is important that BendroCorp takes applicants seriously and does not let applications stagnate. If we are waiting on the applicant to accept the interview then please disregard this notice.</p>"

          # queue the email
          EmailWorker.perform_async user.email, "Dormant Application", email_body
        end

      else
        raise "DormantApplicationWorker could not find any users to notify!"
      end
    end
  end
end
