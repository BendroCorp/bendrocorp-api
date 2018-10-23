class TradeCalculation < ApplicationRecord
  belongs_to :safety_rating, :class_name => 'SystemMapSystemSafetyRating', :foreign_key => 'safety_rating_id' #system_map_system_safety_rating
  belongs_to :user
  belongs_to :owned_ship
  belongs_to :classification_level

  #trade items
  #has_many :trade_item_in_calculations
  #has_many :trade_items, through: :trade_item_in_calculations
  has_many :trade_transactions, :dependent => :delete_all, :class_name => 'TradeCalculationTransaction', :foreign_key => 'trade_calculation_id'

  accepts_nested_attributes_for :trade_transactions

  def created_time_ms
    self.created_at.to_f * 1000
  end
end
