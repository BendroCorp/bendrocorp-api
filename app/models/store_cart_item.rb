class StoreCartItem < ApplicationRecord
  belongs_to :cart, :class_name => 'StoreCart', :foreign_key => 'cart_id'
  belongs_to :item, :class_name => 'StoreItem', :foreign_key => 'item_id'
end
