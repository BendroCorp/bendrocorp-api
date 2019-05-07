class EmailWorker
  include Sidekiq::Worker
  include SendGrid

  def perform(email_to, subject, message)
    outro = "<p><b><strong>Please do not reply to this email.</strong></b><p/><p>Sincerely,</p><p>Kaden Aayhan<br />Assistant to the CEO<br />BendroCorp, Inc.</p><p>Corp Plaza 11, Platform R3Q<br />Crusader, Stanton</p>"
    outro = outro + "<p><small>#{ENV['RAILS_ENV']}</small></p>"
    outro = outro + "<p>#{Digest::SHA256.hexdigest message}</p>" if ENV['RAILS_ENV'] == 'development'

    #
    message_trimmed = message.gsub('localhost:4200', 'my.bendrocorp.com') if ENV["RAILS_ENV"] != nil && ENV["RAILS_ENV"] == 'production'

    # the actual email itself
    from = Email.new(email: 'no-reply@bendrocorp.com')
    to = Email.new(email: email_to)
    content = Content.new(type: 'text/html', value: "#{message_trimmed}#{outro}")
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY']) if ENV['SENDGRID_API_KEY'] != nil

    # log the email sending
    SiteLog.create(module: 'Session', submodule: 'Success', message: "Attempting to send an email to ##{email_to} with the subject: #{subject}", site_log_type_id: 4)

    # send the email through SendGrid if the API key is set
    response = sg.client.mail._("send").post(request_body: mail.to_json) if ENV['SENDGRID_API_KEY'] != nil

    if ENV['SENDGRID_API_KEY'] == nil
      puts
      puts "The email that would have been sent to..."
      puts sg_email_json
      puts
    else
      puts "SendGrid response code:"
      puts response.status_code
      puts
      if response.status_code == 200 || response.status_code == 201 || response.status_code == 202
        return true
      else
        puts response.body
        return false
      end
    end
  end
end
