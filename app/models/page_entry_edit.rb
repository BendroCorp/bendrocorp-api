class PageEntryEdit < ApplicationRecord
  belongs_to :page
  validates :user_id, presence: true
  belongs_to :user, optional: true
end
