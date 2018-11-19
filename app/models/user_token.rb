class UserToken < ApplicationRecord
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  validates :token, presence: true
  validates :device, presence: true

  def perpetual
    self.expires == nil
  end

  def is_expired
    if self.expires == nil
      return false
    else
      self.expires < Time.now
    end
  end

  def expires_ms
    self.expires.to_f * 1000 if self.expires
  end
end
