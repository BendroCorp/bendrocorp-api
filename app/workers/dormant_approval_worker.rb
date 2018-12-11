require 'httparty'
require 'sidekiq-scheduler'

class DormantApprovalWorker
  include Sidekiq::Worker

  def perform(*args)
    puts "Cheching for dormant approvals"
    dormant_approvals = ApprovalApprover.where('approval_type_id < 4 AND created_at <= ?', Time.now - 2.days)

    if dormant_approvals.count > 0
      puts "Found #{dormant_approvals.count} dormant approval(s)!"
      # Email each approver with a dormant approval
      dormant_approvals.each do |approver|
        emailMessage = "<p>#{approver.user.main_character.first_name},</p><p>You have a dormant approval that you need to approve or deny:</p><p><a href=\"https://my.bendrocorp.com/requests/approvals/#{approver.approval_id}\">Approval #{approver.approval_id}</a></p><p>Please correct this issue in a timely manner.</p>"
        EmailWorker.perform_async approver.user.email, "Dormant Approval", emailMessage
      end

      # Send the admins a message
      adminMessage = "<p>Dormant approval check performed with #{dormant_approvals.count} results.</p><p>#{dormant_approvals.join('<br />')}</p><p>Please harass the above individuals if they do not finish their approvals in a timely manner.</p>"
      EmailWorker.perform_async ENV["ADMIN_EMAIL"], "Dormant Approvals", adminMessage

      # Post to the discord channel
      discordAdminMessage = "Dormant approval check performed with #{dormant_approvals.count} results: #{dormant_approvals.join(', ')}. Please harass the above individuals if they do not finish their approvals in a timely manner.</p>"
      HTTParty.post(ENV["DISCORD_MESSAGES"],
        :body => { :content => discordAdminMessage}.to_json, :headers => { 'Content-Type' => 'application/json' } )
    end

    puts "Finished"
  end
end
