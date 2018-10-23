require 'usps_mail_calc'

class StoreController < ApplicationController
  before_action :require_user
  before_action :require_member

  # index, list availabe to all members

  before_action only: [:create_item, :update_item, :archive_item, :create_category, :update_category, :delete_category, :update_order, :refund] do |a|
   a.require_one_role([31]) #store admin
  end

  # GET api/store/item
  def list_items
    render status: 200, json: StoreItem.all.as_json(include: { category: { }, currency_type: { } }, methods: [:original_image, :thumbnail_image, :small_image, :quantity_available, :quantity_sold, :big_image])
  end

  # GET api/store/orders
  def list_orders
    orders = StoreOrder.all.order('created_at desc')
    my_orders = []
    all_orders = [] #if current_user.isinrole(31)

    orders.each do |order|
      my_orders << order if order.cart.user == current_user
      all_orders << order if current_user.isinrole(31)
    end

    render status: 200, json: {
      my_orders: my_orders.as_json(include: { status: {}, cart: { methods: [:cart_currency_type, :cart_total], include: { items: { include: { item: { include: { category: { }, currency_type: { } }, methods: [:original_image, :thumbnail_image, :small_image, :quantity_available, :big_image] } } } } } }, methods: [:created_time_ms, :updated_time_ms, :status]),
      all_orders: all_orders.as_json(include: { status: {}, cart: { methods: [:cart_currency_type, :cart_total], include: { user: { only: [:username], include: { user_information: { methods: [:completed] } } }, items: { include: { item: { include: { category: { }, currency_type: { } }, methods: [:original_image, :thumbnail_image, :small_image, :quantity_available, :big_image] } } } } } }, methods: [:created_time_ms, :updated_time_ms, :status]),
    }
  end

  # GET api/store/types
  def list_types
    render status: 200, json: { user_ops: current_user.points_count, permissions: { isAdmin: current_user.isinrole(31) }, order_statuses: StoreOrderStatus.where('can_select = ?', true), currency_types: StoreCurrencyType.all, categories: StoreItemCategory.all }
  end

  # GET api/store/cart
  def list_cart
    render status: 200, json: {
      current_cart: current_user.current_cart.as_json(methods: [:cart_currency_type], include: { user: { only: [], include: { user_information: { } } }, items: { include: { item: { include: { category: { }, currency_type: { } }, methods: [:original_image, :thumbnail_image, :small_image, :quantity_available, :big_image] } } } })
    }
  end

  # POST api/store/cart
  # Body should include :item_id, :quantity
  def add_to_cart
    # item_id, quantity
    @item = StoreItem.find_by_id(params[:item_id].to_i)
    if @item != nil
      if !@item.locked
        # Need to make sure we are not putting more than one kind of currency_type in the same cart
        if current_user.current_cart.cart_currency_type == nil || (current_user.current_cart.cart_currency_type.id == @item.currency_type_id)
          # Check to see if the item already exists in the cart if so update the quantity
          @item_exists_in_cart = StoreCartItem.where('cart_id = ? AND item_id = ?', current_user.current_cart.id, params[:item_id].to_i)
          if @item_exists_in_cart.count == 1
            total_quantity = @item_exists_in_cart.first.quantity + params[:quantity].to_i
            if total_quantity <= @item.quantity_available

              # Fix the quantity in the cart
              @item_exists_in_cart.first.quantity = total_quantity

              # update the item
              if @item_exists_in_cart.first.save
                render status: 200, json: @item_exists_in_cart
              else
                render status: 500, json: { message: 'Error Occured: Item could not be added to cart' }
              end
            else
              render status: 403, json: { message: 'The quantity you have selected is currently not available for that item' }
            end
          elsif @item_exists_in_cart.count > 1
            render status: 500, json: { message: 'Error Occured: Current cart has more than once instance of the same product in the cart. This should not occur.' }
          else
            if params[:quantity].to_i <= @item.quantity_available
              if StoreCartItem.create(item_id: @item.id, cart_id: current_user.current_cart.id, quantity: params[:quantity].to_i)
                render status: 200, json: @item
              else
                render status: 500, json: { message: 'Error Occured: Item could not be added to cart' }
              end
            else
              render status: 403, json: { message: 'The quantity you have selected is currently not available for that item' }
            end
          end
        else
          render status: 403, json: { message: 'This item has a different currency type than what is in your cart. If you want to add this item you must remove all other items from your cart which have a differing currency type.' }
        end
      else
        render status: 403, json: { message: 'This item is locked and cannot be added to your cart.' }
      end
    else
      render status: 404, json: { message: 'Item not found so it couldn\'t be added to the cart. It may have been removed.'}
    end
    # current_user.current_cart.items << @item
  end

  # DELETE api/store/cart/:item_in_cart_id
  def remove_from_cart
    #item_in_cart_id
    @cart_item = StoreCartItem.where('cart_id = ? AND item_id = ?', current_user.current_cart.id, params[:item_in_cart_id].to_i)
    if @cart_item != nil
      if @cart_item.destroy_all
        render status: 200, json: { message: 'Item removed from cart' }
      else
        render status: 500, json: { message: 'Error Occured: Item could not be removed from cart' }
      end
    else
      render status: 404, json: { message: 'Item not found in cart. It may have been removed.'}
    end
  end

  # GET api/store/shipping
  def fetch_shipping_cost
    if current_user.current_cart.cart_currency_type.id == 1
      shipping = USPSMail.new(current_user.user_information.country, current_user.current_cart.cart_total, current_user.current_cart.cart_total_weight, 73099, current_user.user_information.zip)
      cost = shipping.calculate
      added_shipping_cost = 0
      if cost[:code] == 0 || cost[:code] == 2
        if cost[:code] == 0
          if cost[:rate] > current_user.current_cart.shipping_buffer
            @order.added_shipping_cost = cost[:rate] - current_user.current_cart.shipping_buffer
          end
          render status: 200, json: { shipping_cost: added_shipping_cost, formula: "#{cost[:rate]} - #{current_user.current_cart.shipping_buffer}" }
        elsif cost[:code] == 2
          render status: 200, json: { message: cost[:message] }
        else

        end
      else
        render status: 500, json: { message: cost[:message] }
      end
    else
      render status: 200, json: { shipping_cost: 0, message: 'Transaction is not in real life currency.' }
    end
  end

  # GET api/store/checkout
  def checkout #aka create order
    # Check to make sure the cart exists
    if current_user.current_cart != nil
      # Check to make sure that all of the items are in stock
      out_of_stock_items = []
      current_user.current_cart.items.each do |cart_item|
        out_of_stock_items << cart_item if cart_item.quantity > cart_item.item.quantity_available
      end
      if out_of_stock_items.count == 0
        @order = StoreOrder.new
        # Its very important that a stock check is done before the order is saved
        # If something is backordered return 403
        # Need to also see how the interaction with stripe works
        # Much of the order management can happen in the front end
        # https://stripe.com/docs/stripe-js/elements/quickstart
        # https://stripe.com/docs/charges

        # get ready to make a charge
        # 1 - Dollars
        # 2 - Op Points
        if current_user.current_cart.cart_total > 0
          if current_user.current_cart.cart_currency_type.id == 1
            # Get shipping cost
            if current_user.user_information.completed
              # Fetch estimated shipping cost
              shipping = USPSMail.new(current_user.user_information.country, current_user.current_cart.cart_total, current_user.current_cart.cart_total_weight, 73099, current_user.user_information.zip)
              cost = shipping.calculate

              # Is the shipping cost more than the shipping buffer?
              # If it is then add the cost of shipping
              if cost[:rate] > current_user.current_cart.shipping_buffer
                @order.added_shipping_cost = cost[:rate] - current_user.current_cart.shipping_buffer
              else
                @order.added_shipping_cost = 0
              end

              # if its dollars we need to make a stripe charge
              if ENV['RAILS_ENV'] == 'development'
                puts 'Using Test Stripe env'
                Stripe.api_key = "sk_test_5XT6Ve3VgDkohMPptPsRtm6t"
              else
                puts 'Using Production Stripe env'
                Stripe.api_key = ENV["STRIPE_API_KEY"]
              end

              # Token is created using Checkout or Elements!
              # Get the payment token ID submitted by the form:
              token = params[:stripe_token][:id]

              # Charge the user's card:
              charge = Stripe::Charge.create(
                :amount => (current_user.current_cart.cart_total.to_i * 100) + @order.added_shipping_cost, # the charge unit in cents so to get it to dollars we times by 100 https://stripe.com/docs/currencies#zero-decimal
                :currency => "usd",
                :description => "Purchase from the BendroCorp web site by #{current_user.username}",
                :source => token,
              )

              if charge.id != nil
                @order.stripe_transaction_id = charge.id
              else
                raise 'Error: Could not retrieve charge id from Stripe.'
              end
            else
              render status: 403, json: { message: "Your user information is not complete. We cannot process this transaction without it!" }
              return
            end
          elsif current_user.current_cart.cart_currency_type.id == 2
            # Check to make sure the user has enough operations points to complete the transaction
            # NOTE: PointTransaction.create(user_id: User.all[1].id, amount: 5000, approved: true, reason: "Debug Money")
            if current_user.points_count >= current_user.current_cart.cart_total
              # We need to make an OP transaction
              pt = PointTransaction.create(user_id: current_user.id, amount: -(current_user.current_cart.cart_total), approved: true, reason: "BendroCorp store purchase.")
              @order.point_transaction_id = pt.id
            else
              render status: 403, json: { message: "You do not have enough operations points to complete this transaction." }
              return #exit out without completing the transaction
            end
          else
            raise 'Currency type not handled.'
          end
          # Finished order charge
          @order.payment_processed = true

          # set order status
          @order.status_id = 1

          # Map the current cart to the order
          @order.cart = current_user.current_cart

          # Save order
          if @order.save
            @cart = current_user.current_cart
            @cart.order = @order
            if @cart.save
              # TODO: Email the user
              # TODO: Email store admins about the order
              render status: 201, json: { message: "Order created and cart updated. #{@order.id}", order: @order, cart: @cart }
            else
              render status: 500, json: { message: 'Error Occured: Cart could not be updated.' }
            end
          else
            # Need to reverse any charges if an error occured
            if pt != nil
              pt.destroy
            end

            if charge.id != nil
              # if its dollars we need to make a stripe charge
              if ENV['RAILS_ENV'] == 'development'
                puts 'Using Test Stripe env'
                Stripe.api_key = "sk_test_5XT6Ve3VgDkohMPptPsRtm6t"
              else
                puts 'Using Production Stripe env'
                Stripe.api_key = ENV["STRIPE_API_KEY"]
              end

              # refund the user's card
              refund = Stripe::Refund.create(
                charge: charge.id
              )
            end
          end
        end
      else
        render status: 403, json: { message: 'One or more items in your cart is out of stock or has insufficient stock.' }
      end
    else
      render status: 500, json: { message: 'Error Occured: You do not have a current cart' }
    end
  end

  # POST api/store/refund
  # Body must contain :order_id
  def refund_order
    @order = StoreOrder.find_by_id(params[:order_id])
    if @order != nil
      # NOTE: The order status must be completed to be refunded
      if @order.status_id == 4
        if @order.cart.cart_currency_type.id == 1
          # if its dollars we need to make a stripe charge
          if ENV['RAILS_ENV'] == 'development'
            puts 'Using Test Stripe env'
            Stripe.api_key = "sk_test_5XT6Ve3VgDkohMPptPsRtm6t"
          else
            puts 'Using Production Stripe env'
            Stripe.api_key = ENV["STRIPE_API_KEY"]
          end

          if @order.stripe_transaction_id != nil
            # Charge the user's card:
            refund = Stripe::Refund.create(
              charge: @order.stripe_transaction_id
            )

            if refund.id != nil
              @order.stripe_refund_id = refund.id
            else
              raise 'Error: Could not retrieve charge id from Stripe.'
            end
          else
            raise 'Error: Stripe transaction id not found'
          end
        elsif @order.cart.cart_currency_type.id == 2
          if @order.point_transaction_id != nil
            # We need to make an OP transaction
            pt = PointTransaction.create(user_id: current_user.id, amount: @order.point_transaction.amount.abs, approved: true, reason: "Refund for BendroCorp store purchase.")
          else
            render status: 403, json: { message: "You do not have enough operations points to complete this transaction." }
            return #exit out without completing the transaction
          end
        else
          raise 'Currency type not handled.'
        end

        @order.status_id = 5 #refunded

        # save back the order
        if @order.save
          render status: 200, json: { message: 'Refund processed.'}
        else
          render status: 500, json: { message: 'Error Occured. Refund could not be processed.'}
        end
      else
        render status: 403, json: { message: 'Order status must be changed to cancelled before this order can be processed.'}
      end
    else
      render status: 404, json: { message: 'Order was not found. It has been removed.'}
    end
  end

  def payment_callback
    # This is for stripe - need to research how this actually works
  end

  # POST api/store/item
  def create_item
    @item = StoreItem.new(item_params)
    @item.creator = current_user
    @item.last_updated_by = current_user
    if @item.currency_type_id != 1
      @item.weight = nil
      @item.max_shipping_cost = nil
    end
    if params[:item][:new_image] != nil
      @item.image = "data:#{params[:item][:new_image][:filetype]};base64,#{params[:item][:new_image][:base64]}"
      @item.image_file_name = params[:item][:new_image][:filename]

      # image: "data:#{image[:image][:filetype]};base64,#{image[:image][:base64]}",
      # image_file_name: image[:image][:filename]
    end
    if @item.save
      render status: 200, json: { message: 'Item created.' }
    else
      render status: 500, json: { message: 'Error Occured: Item could not be created.' }
    end
  end

  # PATCH api/store/item
  def update_item
    @item = StoreItem.find_by_id(params[:item][:id].to_i)
    if @item != nil
      @item.last_updated_by = current_user
      if @item.update_attributes(item_params)
        if @item.currency_type_id != 1
          @item.weight = nil
          @item.max_shipping_cost = nil
        end
        if params[:item][:new_image] != nil
          @item.image = "data:#{params[:item][:new_image][:filetype]};base64,#{params[:item][:new_image][:base64]}"
          @item.image_file_name = params[:item][:new_image][:filename]
        end
        if @item.save
          render status: 200, json: { message: 'Item updated.' }
        else
          render status: 500, json: { message: 'Error Occured: Item could not be updated.' }
        end
      else
        render status: 500, json: { message: 'Error Occured: Item could not be updated.' }
      end
    else
      render status: 404, json: { message: 'Item not found. It may have been removed.'}
    end
  end

  # DELETE api/store/item/:item_id
  def archive_item
    @item = StoreItem.find_by_id(params[:item_id].to_i)
    if @item != nil
      @item.last_updated_by = current_user
      @item.archived = true
      if @item.save
        render status: 200, json: { message: 'Item archived.' }
      else
        render status: 500, json: { message: 'Error Occured: Item could not be archived.' }
      end
    else
      render status: 404, json: { message: 'Item not found. It may have been removed.'}
    end
  end

  # POST api/store/category
  def create_category
    @item = StoreItemCategory.new(category_params)
    @item.creator = current_user
    @item.last_updated_by = current_user
    if @item.save
      render status: 200, json: { message: 'Category created.' }
    else
      render status: 500, json: { message: 'Error Occured: Category could not be created.' }
    end
  end

  # PATCH api/store/category
  def update_category
    @item = StoreItemCategory.find_by_id(params[:category][:id].to_i)
    if @item != nil
      @item.last_updated_by = current_user
      if @item.update_attributes(category_params)
        render status: 200, json: { message: 'Category updated.' }
      else
        render status: 500, json: { message: 'Error Occured: Category could not be updated.' }
      end
    else
      render status: 404, json: { message: 'Category not found. It may have been removed.'}
    end
  end

  # delete api/store/category/:category_id
  def delete_category
    @category = StoreItemCategory.find_by_id(params[:category_id].to_i)
    if @category != nil
      @items = StoreItem.where('category_id = ?', @category.id)

      # remove this category from any items which are in it
      @items.each do |item|
        item.category_id = nil
        if !item.save
          raise 'Error Occured: An item could not be saved.'
        end
      end

      if @category.destroy
        render status: 200, json: { message: 'Category archived.' }
      else
        render status: 500, json: { message: 'Error Occured: Category could not be archived.' }
      end
    else
      render status: 404, json: { message: 'Category not found. It may have been removed.'}
    end
  end

  # Admin processing functions located below here
  # PATCH api/store/order
  # Store admin only
  # Body should contain :order[:id|:tracking_number|:new_status_id]
  def update_order
    @order = StoreOrder.find_by_id(params[:order_id])
    if @order != nil
      @order.tracking_number = params[:tracking_number]
      if @order.status_id != params[:new_status_id].to_i
        @order.status_id = params[:new_status_id].to_i
        if @order.status_id = 3 && @order.tracking_number == nil
          render status: 400, json: { message: 'To change an order to shipped you must provide a tracking number.'}
          return
        end
        # TODO: Email the order owner about status changes
      end
      @order.last_updated_by = current_user
      if @order.save
        render status: 200, json: { message: 'Order updated.' }
      else
        render status: 500, json: { message: 'Error occured. Order could not be updated.' }
      end
    else
      render status: 404, json: { message: 'Order not found. It may have been removed.'}
    end
  end

  # Defs
  private
  def item_params
    params.require(:item).permit(:id, :title, :description, :cost, :currency_type_id, :category_id, :base_stock, :size, :show_in_store, :locked, :max_shipping_cost, :weight)
  end

  private
  def category_params
    params.require(:category).permit(:id, :title)
  end
end
