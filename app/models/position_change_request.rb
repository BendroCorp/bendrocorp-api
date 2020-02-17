class PositionChangeRequest < ApplicationRecord
  validates :user_id, presence: true
  belongs_to :user, optional: true # required field/fk - the requester
  belongs_to :approval # required field/fk
  belongs_to :job
  belongs_to :character

  accepts_nested_attributes_for :character

  def approval_completion #what happens when the approval is approved
    self.character.jobs << self.job
    self.save

    # if its a "leave out" job. remove them as a member
    # Retired, Discharged, Withdrawn
    if self.job_id == 22 || self.job_id == 23 || self.job_id == 24
      if self.character.user.is_in_one_role([0])
        # revoke all of their refresh tokens
        u_t = UserToken.where(user_id: self.character.user_id)
        u_t.destroy_all

        member_role_in = InRole.where(user_id: self.character.user_id, role_id: 0)
        member_role_in.destroy_all if member_role_in

        # exec notification
        Role.find_by_id(2).role_full_users.each do |exec_user|
          PushWorker.perform_async exec_user.id, "#{self.character.full_name} has been #{self.job.title} from BendroCorp"
          email_body = "<p>Hello #{exec_user.main_character.first_name},</p><p>This message is notify you that #{self.character.full_name} moved to a #{self.job.title} status.</p><p>As a result they have lost their membership to BendroCorp.</p><p>This action was requested by: #{self.user.main_character.full_name}, #{self.user.main_character.current_job_title}.</p>"
          EmailWorker.perform_async exec_user.email, "Member #{self.job.title} by Change Request", email_body
        end

        # if its a discharge or retirement, notify the user
        if self.job_id == 23 # discharged
          email_body = "<p>Hello #{self.character.first_name},</p><p>This email is to notify you that your position within BendroCorp has been changed to: #{self.job.title}.</p><p>As a result you have been removed as a member of BendroCorp. This typically occurs as a result of a long unexplained period of inactivity and/or failure to meet probationary requirements.</p><p>This action was requested by: #{self.user.main_character.full_name}, #{self.user.main_character.current_job_title}.</p>"
          EmailWorker.perform_async self.character.user.email, 'Loss of Membership', email_body
        elsif self.job_id == 22 # retired
          email_body = "<p>Hello #{self.character.first_name},</p><p>This email is to notify you that your position within BendroCorp has been changed to: #{self.job.title}.</p><p>As a result you have been removed as a member of BendroCorp. As a retired member you may rejoin at any time by contacting your original Division Director. If this occured in error please contact on Discord or Spectrum ASAP.</p><p>This action was requested by: #{self.user.main_character.full_name}, #{self.user.main_character.current_job_title}.</p>"
          EmailWorker.perform_async self.character.user.email, 'Retirement', email_body
        end
      end
    else
      # send a normal notification to the user
      email_body = "<p>Hello #{self.character.first_name},</p><p>This email is to notify you that your position within BendroCorp has been changed to: #{self.job.title}.</p><p>This action was requested by: #{self.user.main_character.full_name}, #{self.user.main_character.current_job_title}</p>"
      EmailWorker.perform_async self.character.user.email, 'Position Change', email_body
    end
  end

  def approval_denied
    # do nothing
  end
end
