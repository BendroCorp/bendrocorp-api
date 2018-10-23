class TradeItemInCalculation < ApplicationRecord
  belongs_to :trade_item
  belongs_to :trade_calculation
end
