class TradeCalculationsController < ApplicationController
  before_action :require_user
  before_action :require_member
  # may further lock this down
  # before_action except: [] do |a|
  #   a.require_one_role([9]) #for now CEO only :)
  # end
  #
  # def list
  #   @trade_calculations = TradeCalculation.where('user_id = ?', current_user.id).order('created_at desc')
  #
  #   @trade_items = TradeItem.all#.joins(:trade_item_value).where(:trade_item_values => { :is_finalized => true } )
  #   @owned_ships = current_user.main_character.owned_ships
  #   @locations = SystemMapSystemPlanetaryBodyLocation.all
  #
  #   render :json => {
  #     :trade_calculations => @trade_calculations.as_json(include: { trade_transactions: { include: { trade_item: { methods: [:sell_value_best, :buy_value_best] }, trade_item_value_buy: { include: { location: {} } }, trade_item_value_sell: { include: { location: {} } } }, methods: [:entered_trade_name] } }, methods: [:created_time_ms]),
  #     :trade_items => @trade_items.as_json(include: { trade_item_values: {} }),
  #     :your_ships => @owned_ships,
  #     :system_map_locations => @locations
  #   }
  # end
  #
  # def create
  #
  #   if params[:trade_calculation][:trade_transactions_attributes] != nil
  #     @tc = TradeCalculation.new() #trade_calculation_params
  #     params[:trade_calculation][:trade_transactions_attributes].each do |trans|
  #       #look up trade item
  #       tt = TradeCalculationTransaction.new()
  #
  #       # add quantities
  #       tt.buy_quantity = trans[:buy_quantity]
  #       tt.sell_quantity = trans[:sell_quantity]
  #
  #       #handle the trade item
  #       if trans[:trade_item_value_buy_attributes][:trade_item_id] != nil
  #         tt.trade_item_id = trans[:trade_item_value_buy_attributes][:trade_item_id].to_i
  #       else
  #         ti = TradeItem.new
  #         ti.title = trans[:entered_trade_name] #params[:trade_calculation][:trade_item_attributes]
  #         if ti.save #save new trade item back
  #           tt.trade_item_id = ti.id
  #         else
  #           render status: 500, json: { message: "Error Occured: New Trade Item could not be saved." }
  #         end
  #       end
  #
  #       # handle sell and buy values
  #       tiv_buy = TradeItemValue.new #trade_item_value_buy_attributes "buy_price"=>"10", "location_id"=>1
  #       tiv_buy.buy_price = trans[:trade_item_value_buy_attributes][:buy_price].to_i
  #       tiv_buy.location_id = trans[:trade_item_value_buy_attributes][:location_id].to_i
  #       tt.trade_item_value_buy = tiv_buy
  #
  #       tiv_sell = TradeItemValue.new  #trade_item_value_sell_attributes "buy_price"=>"10", "location_id"=>1
  #       tiv_sell.sell_price = trans[:trade_item_value_sell_attributes][:sell_price].to_i
  #       tiv_sell.location_id = trans[:trade_item_value_sell_attributes][:location_id].to_i
  #       tt.trade_item_value_sell = tiv_sell
  #
  #       tt.trade_item_value_buy.trade_item_id = tt.trade_item.id
  #       tt.trade_item_value_sell.trade_item_id = tt.trade_item.id
  #       tt.trade_item_value_buy.added_by = current_user
  #       tt.trade_item_value_sell.added_by = current_user
  #
  #       #add the new transaction to the list
  #       @tc.trade_transactions << tt
  #     end #end tt loop
  #
  #     @tc.user = current_user
  #     if @tc.save
  #       render status: 200, json: { message: "New trade calculation created." }
  #     else
  #       render status: 500, json: { message: "New trade calculation trade item ids could not be updated." }
  #     end
  #   else
  #     render status: 500, json: { message: "No trade transactions received." }
  #   end
  # end
  #
  # def update
  #   @tc = TradeCalculation.find_by_id(params[:tc_id])
  #   if @tc != nil
  #     if !@tc.is_finalized
  #       if @tc.user == current_user || current_user.isinrole(27) # is this the current users calc or are you a tc admin :)
  #
  #         # new logic here
  #         # loop through transactions
  #         params[:trade_calculation][:trade_transactions_attributes].each do |trans|
  #           # look up each one, if found update, if not found create
  #           puts
  #           puts ":'#{trans[:id]}':"
  #           puts
  #           if trans[:id] != nil
  #             # can we find it?
  #             tt = TradeCalculationTransaction.find_by_id(trans[:id].to_i)
  #             if tt != nil
  #               # update
  #               # add quantities
  #               tt.buy_quantity = trans[:buy_quantity]
  #               tt.sell_quantity = trans[:sell_quantity]
  #
  #               #handle the trade item
  #               # still need to check if its a new item because the user could change it
  #               if trans[:trade_item_value_buy_attributes][:trade_item_id] != nil
  #                 tt.trade_item_id = trans[:trade_item_value_buy_attributes][:trade_item_id].to_i
  #               else
  #                 ti = TradeItem.new
  #                 ti.title = trans[:trade_item_attributes][:title]
  #                 if ti.save
  #                   tt.trade_item_id = ti.id
  #                 else
  #                   render status: 500, json: { message: "Error Occured: New Trade Item could not be saved." }
  #                   return
  #                 end
  #               end
  #
  #               # handle sell and buy values
  #               tt.trade_item_value_buy.buy_price = trans[:trade_item_value_buy_attributes][:buy_price].to_i
  #               tt.trade_item_value_buy.location_id = trans[:trade_item_value_buy_attributes][:location_id].to_i
  #
  #               tt.trade_item_value_sell.sell_price = trans[:trade_item_value_sell_attributes][:sell_price].to_i
  #               tt.trade_item_value_sell.location_id = trans[:trade_item_value_sell_attributes][:location_id].to_i
  #
  #               tt.trade_item_value_buy.trade_item_id = tt.trade_item.id
  #               tt.trade_item_value_sell.trade_item_id = tt.trade_item.id
  #             else
  #               render status: 404, json: { message: "Trade transaction id could not be found. Trans id #{}" }
  #               return
  #             end
  #           else
  #             # create/new
  #             tt = TradeCalculationTransaction.new()
  #
  #             # add quantities
  #             tt.buy_quantity = trans[:buy_quantity]
  #             tt.sell_quantity = trans[:sell_quantity]
  #
  #             #handle the trade item
  #             if trans[:trade_item_value_buy_attributes][:trade_item_id] != nil
  #               tt.trade_item_id = trans[:trade_item_value_buy_attributes][:trade_item_id].to_i
  #             else
  #               ti = TradeItem.new
  #               ti.title = trans[:trade_item_attributes][:title]
  #               if ti.save
  #                 tt.trade_item_id = ti.id
  #               else
  #                 render status: 500, json: { message: "Error Occured: New Trade Item could not be saved." }
  #                 return
  #               end
  #             end
  #
  #             # handle sell and buy values
  #             tiv_buy = TradeItemValue.new #trade_item_value_buy_attributes "buy_price"=>"10", "location_id"=>1
  #             tiv_buy.buy_price = trans[:trade_item_value_buy_attributes][:buy_price].to_i
  #             tiv_buy.location_id = trans[:trade_item_value_buy_attributes][:location_id].to_i
  #             tt.trade_item_value_buy = tiv_buy
  #
  #             tiv_sell = TradeItemValue.new  #trade_item_value_sell_attributes "buy_price"=>"10", "location_id"=>1
  #             tiv_sell.sell_price = trans[:trade_item_value_sell_attributes][:sell_price].to_i
  #             tiv_sell.location_id = trans[:trade_item_value_sell_attributes][:location_id].to_i
  #             tt.trade_item_value_sell = tiv_sell
  #
  #             tt.trade_item_value_buy.trade_item_id = tt.trade_item.id
  #             tt.trade_item_value_sell.trade_item_id = tt.trade_item.id
  #             tt.trade_item_value_buy.added_by = current_user
  #             tt.trade_item_value_sell.added_by = current_user
  #
  #             #add the new transaction to the list
  #             @tc.trade_transactions << tt
  #           end
  #         end
  #         if @tc.save #update(trade_calculation_params)
  #           render status: 200, json: { message: "Trade calculation updated." }
  #         else
  #           render status: 500, json: { message: "Something went wrong. Trade calculation could not be updated." }
  #         end
  #       else
  #         render status: 403, json: { message: "You do not have access to remove this trade calculation." }
  #       end
  #     else
  #       render status: 403, json: { message: "This trade calculation has been finalized and can no longer be edited." }
  #     end
  #   else
  #     render status: 404, json: { message: "Trade calculation not found." }
  #   end
  # end
  #
  # # get 'tools/trade-calculator/:tc_id/destroy' => 'trade_calculations#destroy'
  # def destroy
  #   @tt = TradeCalculation.find_by_id(params[:tc_id].to_i)
  #   if @tt != nil
  #     if (!@tt.is_finalized && @tc.user == current_user) || current_user.isinrole(27) #or check user role here
  #       if @tt.destroy
  #         render status: 200, json: { message: "Trade calculation removed." }
  #       else
  #         render status: 500, json: { message: "Something went wrong. Trade calculation could not be destroyed." }
  #       end
  #     else
  #       render status: 403, json: { message: "This trade calculation has been finalized. Only a trade calculator admin can remove it." }
  #     end
  #   else
  #     render status: 404, json: { message: "Trade calculation not found." }
  #   end
  # end
  #
  # # get 'tools/trade-calculator/rt/:trans_id'
  # def destroy_transaction
  #   @tt = TradeCalculationTransaction.find_by_id(params[:trans_id].to_i)
  #   if @tt != nil
  #     if @tt.destroy
  #       render status: 200, json: { message: "Trade transaction removed." }
  #     else
  #       render status: 500, json: { message: "Something went wrong. Trade transaction could not be destroyed." }
  #     end
  #   else
  #     render status: 404, json: { message: "Trade transaction not found." }
  #   end
  # end
  #
  # def finalize_calculation
  #   @tc = TradeCalculation.find_by_id(params[:tc_id].to_i)
  #   if @tc != nil
  #     if @tc.user == current_user
  #       @tc.is_finalized = true
  #
  #       @tc.trade_transactions.each do |tt|
  #         tt.trade_item_value_buy.is_finalized = true
  #         tt.trade_item_value_sell.is_finalized = true
  #       end
  #
  #       if @tc.save
  #         render status: 200, json: { message: "Trade calculation finalized." }
  #       else
  #         render status: 500, json: { message: "Trade calculation could not be finalized." }
  #       end
  #     else
  #       render status: 403, json: { message: "You are not authorized to finalize this trade calculation." }
  #     end
  #   else
  #     render status: 404, json: { message: "Trade calculation not found with id# #{params[:tc_id]}." }
  #   end
  # end
  #
  # private
  # def trade_calculation_params
  #   params.require(:trade_calculation).permit(:id, trade_transactions_attributes: [:id, :title, :buy_quantity, :sell_quantity, trade_item_value_buy_attributes: [:id, :buy_price, :location_id], trade_item_value_sell_attributes: [:id, :sell_price, :location_id], trade_item_attributes: [:id, :title] ])
  # end
end
