class UserPushToken < ApplicationRecord
  belongs_to :user_device_type, optional: true
  belongs_to :user, optional: true

  validates :user_device_type_id, presence: true
  validates :user_id, presence: true
  validates :token, presence: true
  validates :device_uuid, presence: true, uniqueness: { case_sensitive: false }
end
