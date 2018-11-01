class UserToken < ApplicationRecord
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'

  def is_expired?
    self.expires < Time.now
  end

  def expires_ms
    self.expires.to_f * 1000 if self.expires
  end
end
