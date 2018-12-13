class DeadUserWarningWorker
  include Sidekiq::Worker

  def perform(*args)
    User.all.select { |u| u.characters.count == 0 && u.created_at + 15.days < Time.now && !u.removal_warned }.each do |dead_user|
      # Email
      email_body = "<p>Hello #{u.username},</p><p>This email is to notify you that your user account has existed on the BendroCorp portal for fifteen (15) days without having applied to BendroCorp. We require all users who create a user account on the BendroCorp Portal to apply to BendroCorp within a maximum of thirty (30) days.</p><p>Since you have not done so your account is being removed. If you would still like to apply to BendroCorp you may re-create your user account and do so at any time. You will receive no further emails from BendroCorp until you re-create your account.</p>"

      user.removal_warned = true
      if user.save
        EmailWorker.perform_async user.email, "BendroCorp Account Removal Warning ", email_body
      else
        raise "DeadUserWarningWorker could not save user warning because: #{user.errors.full_messages.to_sentence}"
      end
    end
  end
end
