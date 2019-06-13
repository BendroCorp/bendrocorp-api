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
        PushWorker.perform_async approver.user.id, "Your approval for approval ##{approver.approval.id} is dormant and requires your attention."
      end

      # Compose the admin email message
      adminMessage = "<p>Dormant approval check performed with #{dormant_approvals.count} results:</p><p>#{dormant_approvals.map { |approver| "#{approver.user.main_character.full_name}: Approval ##{approver.approval.id} #{approver.approval.approval_kind.title}" }.join('<br />')}</p><p>Please harass the above individuals if they do not finish their approvals in a timely manner.</p>"

      # Notify the CEO
      Role.find_by_id(9).role_full_users.each do |user|
        PushWorker.perform_async user.id, "Approval worker found #{dormant_approvals.count} dormant approval(s)."
        EmailWorker.perform_async user.email, "Dormant Approvals", adminMessage
      end

      # Notify the COO
      Role.find_by_id(10).role_full_users.each do |user|
        PushWorker.perform_async user.id, "Approval worker found #{dormant_approvals.count} dormant approval(s)."
        EmailWorker.perform_async user.email, "Dormant Approvals", adminMessage
      end

      # Post to the discord channel
      discordAdminMessage = "Dormant approval check performed with #{dormant_approvals.count} results: #{dormant_approvals.map { |approver| approver.user.main_character.full_name }.join(', ')}. Please harass the above individuals if they do not finish their approvals in a timely manner.</p>"
      HTTParty.post(ENV["DISCORD_MESSAGES"],
        :body => { :content => discordAdminMessage}.to_json, :headers => { 'Content-Type' => 'application/json' } )
    end

    puts "Finished"
  end
end
