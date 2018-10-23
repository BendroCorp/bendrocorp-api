class MenuItemRole < ApplicationRecord
  validates :role_id, presence: true
  validates :menu_item_id, presence: true

  belongs_to :menu_item
  belongs_to :role
end
