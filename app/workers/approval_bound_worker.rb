# Takes an approval and "binds" it to the user and sends them approval notifications.
class ApprovalBoundWorker
  include Sidekiq::Worker

  def perform(*args)
    # Approval.all[0].approval_approvers[0].user
    # get all of the checkable approvals
    Approval.where(bound: false).each do |approval|
      if approval.is_bound?
        approval.bound = true

        approval.approval_approvers.each do |approver|
          # send push notifications
          PushWorker.perform_async(
            approver.user.id,
            'You have a new Approval Request',
            'APPROVAL',
            { approver_id: approver.id } # approver id not approval id? Oversight?
          )

          # send emails
          EmailWorker.perform_async(approver.user.email, "New Approval Request",
          "<p>Hello #{approver.user.username}!</p><p>You have a new request which requires your approval. Please see <a href=\'http://localhost:4200/approvals/#{approval.id}\'>Approval ##{approval.id}</a> for more information.</p>"
          ) # to, subject, message

          approver.last_notified = Time.now
          approver.save!
        end

        approval.bound = true
        approval.notifications_sent = true
      else
        approval.bound_tries += 1
      end

      # save any changes to the approval
      approval.save!
    end

    # get rid of all the still unbound approvals
    Approval.where('bound_tries >= ? AND bound = ?', 10, false).destroy_all
  end
end
