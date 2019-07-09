class ApplicationComment < ActiveRecord::Base
  belongs_to :application
  validates :user_id, presence: true
  belongs_to :user, optional: true

  def commenter_name
    self.user.main_character.full_name
  end

  def avatar_url
    self.user.main_character.avatar_url
  end
end
