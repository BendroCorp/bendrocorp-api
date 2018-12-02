class DonationController < ApplicationController
  before_action :require_user, except: []
  before_action :require_member, except: []

  before_action only: [:create, :update, :archive] do |a|
    a.require_one_role([2]) #executive
  end

  # GET api/donation
  def list
    render status: 200, json: DonationItem.where(archived: false).as_json(include: { donations: { include: { user: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } }, methods: [:total_donations, :is_completed])
  end

  # GET api/donation/:donation_item_id
  def fetch
    @item = DonationItem.find_by_id(params[:donation_item_id])
    if @item
      render status: 200, json: @item.as_json(include: { donations: { include: { user: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } }, methods: [:total_donations, :is_completed])
    else
      render status: 404, json: { message: "Donation item not found!" }
    end
  end

  # POST api/donation/
  def create
    @item = DonationItem.new(donation_item_params)
    @item.ordinal = DonationItem.all.count + 1
    @item.created_by = current_user
    if @item.save
      render status: 200, json: @item.as_json(include: { donations: { include: { user: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } }, methods: [:total_donations, :is_completed])
    else
      render status: 500, json: { message: "Donation item could not be created because: #{@item.errors.full_messages.to_sentence}" }
    end
  end

  # PUT|PATCH api/donation/
  def update
    @item = DonationItem.find_by_id(params[:donation_item][:id])
    if @item
      if @item.update_attributes(donation_item_params)
        render status: 200, json: @item.as_json(include: { donations: { include: { user: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } }, methods: [:total_donations, :is_completed])
      else
        render status: 500, json: { message: "Donation item could not be updated because: #{@item.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: "Donation item not found!" }
    end
  end

  # GET api/donation/mine
  def my_donations
    render status: 200, json: Donation.where(user: current_user).as_json(include: { donation_item: { } })
  end

  # DELETE api/donation/:donation_item_id
  def archive
    @item = DonationItem.find_by_id(params[:donation_item_id])
    if @item
      @item.archived = true
      if @item.save
        render status: 200, json: @item.as_json(include: { donations: { include: { user: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } }, methods: [:total_donations, :is_completed])
      else
        render status: 500, json: { message: "Donation item could not be archived because: #{@item.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: "Donation item not found!" }
    end
  end

  # POST api/donation/make
  # Must contain donation_params and [:stripe_token][:id]
  def donate
    @new_donation = Donation.new(donation_params)
    
    # Add the current_user as the doner
    @new_donation.user = current_user

    # Make sure the donation amount is an int
    @new_donation.amount = @new_donation.amount.to_i

    if @new_donation.amount >= 1
      # save the donation on our side
      if @new_donation.save
        begin
          # start the process of creating a charge
          # Get the stripe key
          if ENV['RAILS_ENV'] == 'production'
            puts 'Using Production Stripe env'
            Stripe.api_key = ENV["STRIPE_API_KEY"]
          else
            puts 'Using Test Stripe env'
            Stripe.api_key = "sk_test_5XT6Ve3VgDkohMPptPsRtm6t"
          end

          # Token is created using Checkout or Elements!
          # Get the payment token ID submitted by the form:
          token = params[:donation][:card_token]

          # Charge the user's card:
          charge = Stripe::Charge.create(
            :amount => (@new_donation.amount * 100).to_i, # the charge unit in cents - https://stripe.com/docs/currencies#zero-decimal
            :currency => "usd",
            :description => "Donation to BendroCorp for #{@new_donation.donation_item.title} by #{current_user.username}",
            :source => token,
          )

          if charge.id != nil
            @new_donation.stripe_transaction_id = charge.id
            @new_donation.charge_succeeded = true
            if @new_donation.save
              render status: 200, json: { message: 'Donation created and charged successfully!' }
            else
              # refund the user's card
              # refund = Stripe::Refund.create(
              #   charge: charge.id
              # )
              render status: 500, json: "We could not save the transaction id back to your donation because: #{@new_donation.errors.full_messages.to_sentence}. The donation did succeed and will be marked as such."
            end
          else
            @new_donation.charge_failed = true
            @new_donation.save!
            render status: 500, json: { message: "We were not able to charge your donation to the card you provided." }
          end
        rescue StandardError => e
          @new_donation.charge_failed = true
          @new_donation.save!
          raise e
        end
      else
        render status: 500, json: { message: "There was a problem with your donation we could not create it because: #{@new_donation.errors.full_messages.to_sentence}. Your card will not be charged." }
      end
    else
      render status: 400, json: { message: "The minimum donation amount is $1." }
    end
  end

  def donation_item_params
    params.require(:donation_item).permit(:title, :description, :goal, :ordinal)
  end

  def donation_params
    params.require(:donation).permit(:amount, :donation_item_id)
  end
end
