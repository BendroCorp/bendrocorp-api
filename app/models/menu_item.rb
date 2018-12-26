class MenuItem < ApplicationRecord
  validates :title, presence: true
  # validates :icon, presence: true
  # validates :link, presence: true
  validates :ordinal, presence: true

  has_many :menu_item_roles
  has_many :roles, through: :menu_item_roles

  has_many :nested_items, :class_name => 'MenuItem', :foreign_key => 'nested_under_id'
end
