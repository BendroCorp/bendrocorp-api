class SubscriptionController < ApplicationController
  before_action :require_user, except: [:callback_for_stripe]
  before_action :require_member, except: [:callback_for_stripe]
  before_action :set_user, except: [:callback_for_stripe]

  # POST api/subscription
  def create
    if params[:create_subscription] && params[:create_subscription][:paymentMethodId]
      begin
        Stripe::PaymentMethod.attach(
          params[:create_subscription][:paymentMethodId],
          { customer: @customer_id }
        )
      rescue Stripe::CardError => e
        render json: { message: e.error.message }
        return
      end

      # Set the default payment method on the customer
      Stripe::Customer.update(
        @customer_id,
        invoice_settings: { default_payment_method: params[:create_subscription][:paymentMethodId] }
      )

      subscription =
      Stripe::Subscription.create(
        customer: data['customerId'],
        items: [{ price: @price_plan }],
        expand: %w[latest_invoice.payment_intent]
      )

      @user.subscriber_subscription_id = subscription.id

      if @user.save
        render json: { message: 'Subscription added!' }
      else
        Stripe::Subscription.delete(subscription.id)
        render status: 500, json: { message: @user.errors.full_messages.to_sentence }
      end
    else
      render status: 400, json: { message: 'Request not created properly!' }
    end
  end

  # DELETE api/subscription
  def delete
    if @user.is_subscriber
      Stripe::Subscription.delete(subscription.id)
      @user.subscriber_subscription_id = nil
      if @user.save
        render json: { message: 'Subscription removed!' }
      else
        render status: 500, json: { message: @user.errors.full_messages.to_sentence }
      end
    else
      render status: 400, json: { message: 'User not presently a subscriber!' }
    end
  end

  # POST api/subscription/stripe_callback
  def callback_for_stripe
    # https://dev.to/maxencehenneron/handling-stripe-webhooks-with-ruby-on-rails-4bb7
    # https://stripe.com/docs/billing/subscriptions/fixed-price#set-up-webhook-monitoring

    webhook_secret = Rails.application.credentials.stripe_webhook_secret
    payload = request.body.read
    if !webhook_secret.empty?
      # Retrieve the event by verifying the signature using the raw body and secret if webhook signing is configured.
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, webhook_secret
        )
      rescue JSON::ParserError => e
        # Invalid payload
        status 400
        return
      rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        puts '⚠️  Webhook signature verification failed.'
        status 400
        return
      end
    else
      data = JSON.parse(payload, symbolize_names: true)
      event = Stripe::Event.construct_from(data)
    end
    # Get the type of webhook event sent - used to check the status of PaymentIntents.
    event_type = event['type']
    data = event['data']
    data_object = data['object']

    if event_type == 'invoice.paid'
      # Used to provision services after the trial has ended.
      # The status of the invoice will show up as paid. Store the status in your
      # database to reference when a user accesses your service to avoid hitting rate
      # limits.
      # puts data_object
      # data_object.customer should contain the customer id

      # look up the user
      user = User.find_by subscriber_account_id: data_object.customer

      if !user
        render status: 500, json: { message: 'User not found' }
        return
      end

      # select which operating expense item this goes towards
      expense = DonationItem.where(archived: false, donation_type_id: 'e7932112-1e6c-4d54-986f-9c4bfa312f9f').where('goal_date > ?', DateTime.now).order('goal_date').first

      # create the donation
      if expense
        Donation.create(amount: 5, user_id: user.id, donation_item_id: expense.id, charge_succeeded: true, stripe_transaction_id: data_object.id)
      else
        Donation.create(amount: 5, user_id: user.id, charge_succeeded: true, stripe_transaction_id: data_object.id)
      end
    end

    if event_type == 'invoice.payment_failed'
      # If the payment fails or the customer does not have a valid payment method,
      # an invoice.payment_failed event is sent, the subscription becomes past_due.
      # Use this webhook to notify your user that their payment has
      # failed and to retrieve new card details.
      # puts data_object
      # data_object.customer should contain the customer id

      # look up the user
      user = User.find_by subscriber_account_id: data_object.customer

      if !user
        render status: 500, json: { message: 'User not found' }
        return
      end

      # cancel the subscription
      Stripe::Subscription.delete(subscription.id)
      user.subscriber_subscription_id = nil
      user.save!

      # notify the user
      send_email(user.email, 'Support Program - Payment Failed', "<p>#{user.main_character.first_name},</p><p>There was an issue processing your payment for the supporter program. Your subscription has been cancelled. If continue to encouter this error please contact a member of the leadership team.</p>")
    end

    if event_type == 'customer.subscription.deleted'
      # handle subscription cancelled automatically based
      # upon your subscription settings. Or if the user cancels it.
      # puts data_object
      # contains id, we can reference the subscription field to look up the user
      user = User.find_by subscriber_account_id: data_object.id
      user.subscriber_account_id = nil
      user.save!
      send_email(user.email, 'Support Program - Subscription Ended', "<p>#{user.main_character.first_name},</p><p>Your Supporter Program subscription has ended. Thank you for supporting is whiel you were willing and able!</p>")
    end

    render json: { message: 'Success' }
  end

  private
  def set_user
    @user = current_user.db_user
    @customer_id = @user.stripe_customer
  end

  def set_price_plan
    if ENV['RAILS_ENV'] == 'production'
      @price_plan = 'price_1I8rpmDWRJWEDpOmhSPAlaM6' # prod plan
    else
      @price_plan = 'price_1I8qQ2DWRJWEDpOmtZF58PaS' # test plan
    end
  end
end
