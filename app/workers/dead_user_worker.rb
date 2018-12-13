class DeadUserWorker
  include Sidekiq::Worker

  def perform(*args)
    User.all.select { |u| u.characters.count == 0 && u.created_at + 30.days < Time.now }.each do |dead_user|
      # Email
      email_body = "<p>Hello #{u.username},</p><p>This email is to notify you that your user account has been removed from BendroCorp. We require all users who create a user account on the BendroCorp Portal to apply to BendroCorp within a maximum of thirty (30) days.</p><p>Since you have not done so your account is being removed. If you would still like to apply to BendroCorp you may re-create your user account and do so at any time. You will receive no further emails from BendroCorp until you re-create your account.</p>"

      if dead_user.destroy
        # queue the email
        EmailWorker.perform_async user.email, "BendroCorp Account Removal", email_body
      else
        raise "#{u.username} id# #{u.id} could not be removed the BendroCorp database."
      end
    end
  end
end
