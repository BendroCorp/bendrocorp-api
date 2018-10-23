class CommoditiesController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action except: [:index, :list] do |a|
    a.require_one_role([9]) #for now CEO only :)
  end

  # GET api/tools/commodities/
  def list
    # TradeItem.joins(:trade_item_value).where(:trade_item_values => { :is_finalized => true })
    @trade_items = TradeItem.all

    # permissions = {}
    #
    # if current_user.isinrole(27) #admin
    #   permissions = { isEditor: true }
    # else
    #   permissions = { isEditor: false }
    # end

    render status: 200, json: @trade_items.as_json(include: { trade_item_type: { }, trade_item_values: { include: { location: {} }, methods: [:created_time_ms] } }, methods: [:sell_value_best, :buy_value_best, :sell_value_worst, :buy_value_worst, :average_buy, :average_sell, :sell_value_best_location, :buy_value_best_location, :sell_value_worst_location, :buy_value_worst_location] )

    # render :json => {
      # :trade_items => @trade_items.as_json(include: { trade_item_type: { }, trade_item_values: { include: { location: {} }, methods: [:created_time_ms] } }, methods: [:sell_value_best, :buy_value_best, :sell_value_worst, :buy_value_worst, :average_buy, :average_sell, :sell_value_best_location, :buy_value_best_location, :sell_value_worst_location, :buy_value_worst_location] ),
      # :trade_item_types => TradeItemType.all,
      # :permissions => permissions,
      # :locations => SystemMapSystemPlanetaryBodyLocation.all
    # }
  end

  # POST api/tools/commodities
  def create
    @trade_item = TradeItem.new(trade_item_params)
    if @trade_item.save
      render status: 200, json: { message: "Trade item created." }
    else
      render status: 500, json: { message: "Trade item could not be created." }
    end
  end

  # PATCH api/tools/commodities/:ti_id
  def update
    @trade_item = TradeItem.find_by_id(params[:ti_id])
    if @trade_item != nil
      if @trade_item.update_attributes(trade_item_params)
        render status: 200, json: { message: "Trade item updated." }
      else
        render status: 500, json: { message: "Something went wrong. Trade item could not be updated." }
      end
    else
      render status: 404, json: { message: "Trade item not found" }
    end
  end

  # DELETE api/tools/commodities/:ti_id/
  def destroy
    @trade_item = TradeItem.find_by_id(params[:ti_id])
    if @trade_item != nil
      if @trade_item.destroy
        render status: 200, json: { message: "Trade item deleted." }
      else
        render status: 500, json: { message: "Something went wrong. Trade item could not be updated." }
      end
    else
      render status: 404, json: { message: "Trade item not found" }
    end
  end

  # POST api/tools/commodities/:ti_id/value
  def add_values
    saveCount = 0
    params[:trade_values].each do |value|
      @tiv = TradeItemValue.new

      @tiv.location_id = value[:location_id]
      @tiv.trade_item_id = value[:trade_item_id]
      @tiv.buy_price = value[:buy_price]
      @tiv.sell_price = value[:sell_price]
      @tiv.added_by = current_user
      @tiv.is_finalized = true
      @tiv.is_ignored = false

      # save
      if @tiv.save
        saveCount += 1
      end
    end

    if saveCount === params[:values].count
      render status: 200, json: { message: "Values added" }
    else
      render status: 500, json: { message: "All values were not saved." }
    end
  end

  # PATCH api/tools/commodities/:ti_id/value
  # For the most part this will probably not be used too often
  def update_value
    @tiv = TradeItemValue.find_by_id(params[:trade_value][:id])

    if @tiv != nil
      @tiv.location_id = params[:trade_value][:location_id]
      @tiv.trade_item_id = params[:trade_value][:trade_item_id]
      @tiv.buy_price = params[:trade_value][:buy_price]
      @tiv.sell_price = params[:trade_value][:sell_price]

      if @tiv.save
        render status: 200, json: { message: "Trade item value update" }
      else
        render status: 500, json: { message: "Trade item value could not be updated" }
      end
    else
      render status: 404, json: { message: "Trade item value could not be found." }
    end
  end

  # DELETE api/tools/commodities/:ti_id/value/:trade_value_id
  def destroy_value
    @tiv = TradeItemValue.find_by_id(params[:trade_value_id])
    if @tiv != nil
      if @tiv.destroy
        render status: 200, json: { message: "Trade item value deleted" }
      else
        render status: 500, json: { message: "Trade item value could not be deleted" }
      end
    else
      render status: 404, json: { message: "Trade item value could not be found." }
    end
  end

  def bulk_update
    # TODO: Later...maybe :/
    # https://docs.microsoft.com/en-us/azure/cognitive-services/computer-vision/quickstarts/ruby#OCR
    # 5000 free requests per month
  end

  private
  def trade_item_params
    params.require(:trade_item).permit(:id, :title, :description, :trade_item_type_id)
  end
end
