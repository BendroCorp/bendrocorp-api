require 'httparty'
require 'sidekiq-scheduler'

class DormantApprovalWorker
  include Sidekiq::Worker
  include SendGrid

  def perform(*args)
    puts "Cheching for dormant approvals"
    dormant_approvals = ApprovalApprover.where('approval_type_id < 4 AND created_at <= ?', Time.now - 2.days)

    if dormant_approvals.count > 0
      puts "Found #{dormant_approvals.count} dormant approval(s)!"
      # Email each approver with a dormant approval
      dormant_approvals.each do |approver|
        emailMessage = "<p>#{approver.user.main_character.first_name},</p><p>You have a dormant approval that you need to approve or deny:</p><p><a href=\"https://my.bendrocorp.com/requests/approvals/#{approver.approval_id}\">Approval #{approval.approval_id}</a></p><p>Please correct this issue in a timely manner.</p>"
        send_email approver.user.email, "Dormant Approval", emailMessage
      end

      # Send the admins a message
      adminMessage = "<p>Dormant approval check performed with #{dormant_approvals.count} results.</p><p>#{dormant_approvals.join('<br />')}</p><p>Please harass the above individuals if they do not finish their approvals in a timely manner.</p>"
      send_email ENV["ADMIN_EMAIL"], "Dormant Approvals", adminMessage

      # Post to the discord channel
      discordAdminMessage = "Dormant approval check performed with #{dormant_approvals.count} results: #{dormant_approvals.join(', ')}. Please harass the above individuals if they do not finish their approvals in a timely manner.</p>"
      HTTParty.post(ENV["DISCORD_MESSAGES"],
        :body => { :content => discordAdminMessage}.to_json, :headers => { 'Content-Type' => 'application/json' } )
    end

    puts "Finished"
  end

  def send_email email_to, subject, message
    outro = "<p><b><strong>Please do not reply to this email.</strong></b><p/><p>Sincerely,</p><p>Kaden Aayhan<br />Assistant to the CEO<br />BendroCorp, Inc.</p><p>Corp Plaza 11, Platform R3Q<br />Crusader, Stanton</p>"
    outro = outro + "<p><small>#{ENV['RAILS_ENV']}</small></p>"
    outro = outro + "<p>#{Digest::SHA256.hexdigest message}</p>" if ENV['RAILS_ENV'] == 'development'

    # the actual email itself
    from = Email.new(email: 'no-reply@bendrocorp.com')
    to = Email.new(email: email_to)
    content = Content.new(type: 'text/html', value: "#{message}#{outro}")
    mail = SendGrid::Mail.new(from, subject, to, content)
    mail.to_json!

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY']) if ENV['SENDGRID_API_KEY'] != nil
    # send the email through SendGrid if the API key is set
    response = sg.client.mail._("send").post(request_body: mail)  if ENV['SENDGRID_API_KEY'] != nil

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
