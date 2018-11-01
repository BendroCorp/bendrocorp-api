class UserToken < ApplicationRecord
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  validates :token, presence: true
  validates :device, presence: true

  def is_expired?
    if self.expires
      return false
    else
      self.expires < Time.now
    end
  end

  def expires_ms
    self.expires.to_f * 1000
  end
end
