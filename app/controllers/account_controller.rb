class AccountController < ApplicationController
  before_action :require_user
  before_action :require_member

  # POST /api/account/change-password
  # :password[original_password, :password, password_confirmation]
  def change_password
    puts "Starting password change..."
    puts params.inspect
    if current_user.authenticate(params[:password][:original_password])
      if params[:password][:password] === params[:password][:password_confirmation]
        @user = User.find_by_id(current_user.id)
        @user.password = params[:password][:password]
        @user.password_confirmation = params[:password][:password_confirmation]
        if @user.save
          render status: 200, json: { message: 'Password successfully updated.' }
        else
          render status: 500, json: { message: 'ERROR: New password could not be saved.' }
        end
      else
        render status: 403, json: { message: 'Password and confirmation passwords do not match.' }
      end
    else
      render status: 403, json: { message: 'Your original password seems to be incorrect. Please try again.' }
    end
  end

  # GET api/account/fetch-tfa
  def fetch_two_factor_auth
    if !current_user.use_two_factor
      current_user.assign_auth_secret
      if current_user.save
        render status: 200, json: { qr_data_string: "otpauth://totp/bendrocorp?secret=#{current_user.auth_secret}", seed_value: current_user.auth_secret }
      else
        render status: 500, json: { message: 'Error Occured. Could not create auth secret'}
      end
    else
      render status: 403, json: { message: 'Two factor authentication is already enabled on this account' }
    end
  end

  # POST api/account/enable-tfa
  def enable_two_factor_auth
    if current_user.authenticate(params[:two_factor_auth][:password])
      if current_user.two_factor_valid(params[:two_factor_auth][:code])
        @user = User.find_by_id(current_user.id)
        @user.use_two_factor = true
        if @user.save
          render status: 200, json: { message: 'Two factor authentication enabled!.' }
        else
          render status: 500, json: { message: "Two factor could not be enabled on this account because: #{current_user.errors.full_messages.to_sentence}" }
        end
      else
        render status: 403, json: { message: 'Incorrect code try again! Make sure to not include any spaces or dashes.'}
      end
    else
      render status: 403, json: { message: 'The password you entered was incorrect!' }
    end
  end

  def update_user_info
    if current_user.user_information.update_attributes(user_info_params)
      render status: 200, json: { message: 'Personal information updated.' }
    else
      render status: 500, json: { message: 'Error Occured: Personal information could not be updated.' }
    end
  end

  def fetch_user_countries
    render status: 200, json: { user_countries: UserCountry.all.order('title') }
  end

  private
  def password_change_params
    params.require(:password).permit(:original_password, :password, :password_confirmation)
  end

  private
  def user_info_params
    params.require(:user_information).permit(:first_name, :last_name, :street_address, :city, :state, :zip, :country_id)
  end
end
