class ProfileGroupMember < ApplicationRecord
  before_create :set_ordinal

  has_paper_trail

  belongs_to :character, optional: true
  belongs_to :profile_group

  def set_ordinal
    self.ordinal = ProfileGroupMember.where(archived: false).count + 1
  end
end
