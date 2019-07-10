class StoreCart < ApplicationRecord
  validates :user_id, presence: true
  belongs_to :user, optional: true
  belongs_to :order, :class_name => 'StoreOrder', :foreign_key => 'order_id'
  has_many :items, :dependent => :delete_all, :class_name => 'StoreCartItem', :foreign_key => 'cart_id'

  accepts_nested_attributes_for :items

  def cart_currency_type
    currency_types = []
    self.items.each do |item|
      currency_types << item.item.currency_type
    end

    currency_types.uniq!
    if currency_types.count > 1 # there should be none or 1
      raise 'The current cart has items with more that one kind of currency type'
    else
      currency_types[0] #return the first
    end
  end

  def cart_total
    totalCost = 0
    self.items.each do |item|
      totalCost += (item.item.cost * item.quantity)
    end
    totalCost
  end

  def cart_total_weight
    totalWeight = 0
    self.items.each do |item|
      totalWeight += (item.item.weight * item.quantity)
    end
    totalWeight
  end

  def shipping_buffer
    totalShippingBuffer = 0
    self.items.each do |item|
      totalShippingBuffer += (item.item.max_shipping_cost * item.quantity)
    end
    totalShippingBuffer
  end
  # End model
end
