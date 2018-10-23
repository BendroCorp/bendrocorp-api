class TradeItem < ApplicationRecord
  before_save { self.title = title.downcase }
  validates :title, presence: true, length: { maximum: 255 },
                    uniqueness: { case_sensitive: false }

  has_many :trade_item_values

  belongs_to :trade_item_type

  belongs_to :trade_item_container

  belongs_to :best_sell_value, :class_name => 'TradeItemValue', :foreign_key => 'best_sell_value_id'
  belongs_to :worst_sell_value, :class_name => 'TradeItemValue', :foreign_key => 'worst_sell_value_id'
  belongs_to :best_buy_value, :class_name => 'TradeItemValue', :foreign_key => 'best_buy_value_id'
  belongs_to :worst_buy_value, :class_name => 'TradeItemValue', :foreign_key => 'worst_buy_value_id'

  accepts_nested_attributes_for :trade_item_values

  belongs_to :added_by, :class_name => 'User', :foreign_key => 'added_by_id'

  def sell_value_best
    #self.trade_item_values.maximum(:sell_price)
    self.trade_item_values.where('is_finalized = ?', true).order('sell_price DESC').includes(:location).first
  end

  def buy_value_best
    #self.trade_item_values.minimum(:buy_price)
    self.trade_item_values.where('is_finalized = ? AND buy_price <> ?', true, 0).order('buy_price ASC').includes(:location).first
  end

  def sell_value_worst
    #self.trade_item_values.maximum(:sell_price)
    self.trade_item_values.where('is_finalized = ?', true).order('sell_price ASC').includes(:location).first
  end

  def buy_value_worst
    #self.trade_item_values.minimum(:buy_price)
    self.trade_item_values.where('is_finalized = ? AND buy_price <> ?', true, 0).order('buy_price DESC').includes(:location).first
  end

  def sell_value_best_location
    #self.trade_item_values.maximum(:sell_price)
    if self.trade_item_values.where('is_finalized = ?', true).order('sell_price DESC').first != nil
      if self.trade_item_values.where('is_finalized = ?', true).order('sell_price DESC').first.location
        self.trade_item_values.where('is_finalized = ?', true).order('sell_price DESC').first.location.title
      end
    end
  end

  def buy_value_best_location
    if self.trade_item_values.where('is_finalized = ? AND buy_price <> ?', true, 0).order('buy_price ASC').first != nil
      if self.trade_item_values.where('is_finalized = ? AND buy_price <> ?', true, 0).order('buy_price ASC').first.location != nil
        self.trade_item_values.where('is_finalized = ? AND buy_price <> ?', true, 0).order('buy_price ASC').first.location.title
      end
    end
    #self.trade_item_values.minimum(:buy_price)
  end

  def sell_value_worst_location
    #self.trade_item_values.maximum(:sell_price)
    if self.trade_item_values.where('is_finalized = ?', true).order('sell_price ASC').first != nil
      if self.trade_item_values.where('is_finalized = ?', true).order('sell_price ASC').first.location != nil
          self.trade_item_values.where('is_finalized = ?', true).order('sell_price ASC').first.location.title
      end
    end
  end

  def buy_value_worst_location
    #self.trade_item_values.minimum(:buy_price)
    if self.trade_item_values.where('is_finalized = ?', true).order('buy_price DESC').first != nil
      if self.trade_item_values.where('is_finalized = ?', true).order('buy_price DESC').first.location != nil
        self.trade_item_values.where('is_finalized = ?', true).order('buy_price DESC').first.location.title
      end
    end
  end

  #averages
  def average_buy
    num = self.trade_item_values.where('is_finalized = ?', true).average(:buy_price).to_i
    return num
  end

  def average_sell
    num = self.trade_item_values.where('is_finalized = ?', true).average(:sell_price).to_i
    return num
  end
end
