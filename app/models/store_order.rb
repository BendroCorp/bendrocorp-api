class StoreOrder < ApplicationRecord
  belongs_to :status, :class_name => 'StoreOrderStatus', :foreign_key => 'status_id'
  belongs_to :point_transaction
  belongs_to :cart, :class_name => 'StoreCart', :foreign_key => 'cart_id'

  validates :assigned_to_id, presence: true
  belongs_to :assigned_to, :class_name => 'User', :foreign_key => 'assigned_to_id', optional: true
  validates :last_updated_by, presence: true
  belongs_to :last_updated_by, :class_name => 'User', :foreign_key => 'last_updated_by_id', optional: true

  accepts_nested_attributes_for :point_transaction

  def created_time_ms
    self.created_at.to_f * 1000
  end

  def updated_time_ms
    self.updated_at.to_f * 1000
  end
end
