class Page < ActiveRecord::Base
  belongs_to :page_category
  has_many :page_entry_edits
  has_many :page_entry_roles
  has_many :roles, through: :page_entry_roles

  validates :creator_id, presence: true
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'

  accepts_nested_attributes_for :page_entry_edits
  accepts_nested_attributes_for :page_entry_roles
end
