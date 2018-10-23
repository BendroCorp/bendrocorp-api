class TradeCalculationTransaction < ApplicationRecord
  #belongs_to :best_sell_value, :class_name => 'TradeItemValue', :foreign_key => 'best_sell_value_id'
  # https://stackoverflow.com/questions/24090024/adding-existing-has-many-records-to-new-record-with-accepts-nested-attributes-fo
  after_create {
    #
  } # dont remember why I thought I needed this

  belongs_to :trade_calculation
  belongs_to :trade_item, :class_name => 'TradeItem', :foreign_key => 'trade_item_id'
  belongs_to :trade_item_value_buy, :dependent => :destroy, :class_name => 'TradeItemValue', :foreign_key => 'trade_item_value_buy_id'
  belongs_to :trade_item_value_sell, :dependent => :destroy, :class_name => 'TradeItemValue', :foreign_key => 'trade_item_value_sell_id'

  accepts_nested_attributes_for :trade_item
  accepts_nested_attributes_for :trade_item_value_buy
  accepts_nested_attributes_for :trade_item_value_sell

  def entered_trade_name
    if self.trade_item != nil
      self.trade_item.title
    end
  end
end
