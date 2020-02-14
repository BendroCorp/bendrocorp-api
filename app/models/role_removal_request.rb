class RoleRemovalRequest < ApplicationRecord
  belongs_to :user # required field/fk
  belongs_to :role
  belongs_to :approval # required field/fk

  belongs_to :on_behalf_of, class_name: 'Character', foreign_key: 'on_behalf_of_id'

  accepts_nested_attributes_for :approval

  def approval_completion # required for approval
    if self.on_behalf_of.user.in_roles.where(role_id: self.role_id).destroy_all
      if self.role_id == 0 # ie we are removing thier membership
        # revoke all of their refresh tokens
        u_t = UserToken.where(user_id: self.character.user_id)
        u_t.destroy_all
      end
    else
      raise "Could not remove user from role via role request! #{self.inspect}"
    end
  end

  def approval_denied
      # do nothing (nothing needs to be done here)
  end
end
