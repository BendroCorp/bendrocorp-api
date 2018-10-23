class TradeItemValue < ApplicationRecord

  before_save {
    # aka: default values lol >:)
    if self.sell_price == nil
      self.sell_price = 0
    end

    if self.buy_price == nil
      self.buy_price = 0
    end
  }
  
  def created_time_ms
    self.created_at.to_f * 1000
  end
  belongs_to :trade_item
  belongs_to :location, :class_name => 'SystemMapSystemPlanetaryBodyLocation', :foreign_key => 'location_id'
  belongs_to :added_by, :class_name => 'User', :foreign_key => 'added_by_id'
end
