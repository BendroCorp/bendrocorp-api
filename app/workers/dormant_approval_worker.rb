require 'httparty'
require 'sidekiq-scheduler'

class DormantApprovalWorker
  include Sidekiq::Worker

  def perform(*args)
    puts "Checking for dormant approvals"
    dormant_approvals = ApprovalApprover.where('approval_type_id < 4 AND created_at <= ? AND last_notified is not null AND last_notified <= ? AND required = ?', Time.now - 3.days, Time.now - 48.hours, true)
    dormant_approvals_count = dormant_approvals.count

    if dormant_approvals_count > 0
      puts "Found #{dormant_approvals_count} dormant approval(s)!"
      # Email each approver with a dormant approval
      dormant_approvals.each do |approver|
        email_message = "<p>#{approver.user.main_character.first_name},</p><p>You have a dormant approval that you need to approve or deny:</p><p><a href=\"https://my.bendrocorp.com/requests/approvals/#{approver.approval_id}\">Approval #{approver.approval_id}</a></p><p>Please correct this issue in a timely manner.</p>"
        EmailWorker.perform_async approver.user.email, 'Dormant Approval', email_message
        PushWorker.perform_async(
          approver.user.id,
          "We still need your feedback for approval ##{approver.approval.id}. The approval is dormant and requires your attention.",
          'APPROVAL_CHANGE',
          { approver_id: approval_approver.id }
        )

        # update notification date
        approver.last_notified = Time.now
        approver.save!
      end

      # Compose the admin email message
      admin_message = "<p>Dormant approval check performed with #{dormant_approvals_count} results:</p><p>#{dormant_approvals.map { |approver| "#{approver.user.main_character.full_name}: Approval ##{approver.approval.id} #{approver.approval.approval_kind.title}" }.join('<br />')}</p><p>Please harass the above individuals if they do not finish their approvals in a timely manner.</p>"

      # Notify the CEO
      Role.find_by_id(9).role_full_users.each do |user|
        # PushWorker.perform_async user.id, "Approval worker found #{dormant_approvals_count} dormant approval(s)."
        EmailWorker.perform_async user.email, 'Dormant Approvals Report', admin_message
      end

      # Notify the COO
      Role.find_by_id(10).role_full_users.each do |user|
        # PushWorker.perform_async user.id, "Approval worker found #{dormant_approvals_count} dormant approval(s)."
        EmailWorker.perform_async user.email, 'Dormant Approvals Report', admin_message
      end

      # Post to the discord channel
      discord_admin_message = "Dormant approval check performed with #{dormant_approvals_count} results: #{dormant_approvals.map { |approver| approver.user.main_character.full_name }.join(', ')}. Please harass the above individuals if they do not finish their approvals in a timely manner."
      HTTParty.post(ENV["DISCORD_MESSAGES"],
        :body => { :content => discord_admin_message}.to_json, :headers => { 'Content-Type' => 'application/json' } )
    end

    puts "Finished"
  end
end
