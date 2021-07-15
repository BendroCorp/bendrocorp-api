class ProfileGroup < ApplicationRecord
  has_paper_trail

  validates :title, presence: true

  belongs_to :division # temp to carry us over from the old system until we do heiarchies
  belongs_to :parent, optional: true
  belongs_to :slot_status, class_name: 'FieldDescriptor', foreign_key: :slot_status_id
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  belongs_to :division

  has_many :slots, class_name: 'ProfileGroupSlot', foreign_key: :profile_group_id
  has_many :characters, through: :slots
end
