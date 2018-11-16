class AccountController < ApplicationController
  before_action :require_user, except: [:forgot_password, :forgot_password_complete]
  before_action :require_member, except: [:forgot_password, :forgot_password_complete]

  # POST /api/account/change-password
  # :password[original_password, password_confirmation]
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

  # POST /api/account/forgot-password
  # Must include params[:user][:email]
  def forgot_password
    #
    @user = User.find_by email: params[:user][:email]
    SiteLog.create(module: 'Forgot Password', submodule: 'Request', message: "Forgot password request made for user ##{@user.id}!", site_log_type_id: 2) if @user
    if @user && @user.login_allowed
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      new_token = Digest::SHA256.hexdigest (0...50).map { o[rand(o.length)] }.join
      @user.password_reset_token = new_token
      @user.password_reset_requested = true
      if @user.save
        puts "Forgot password request processed"
        SiteLog.create(module: 'Forgot Password', submodule: 'Success', message: "Forgot password request successfully made for user ##{@user.id}!", site_log_type_id: 2) if @user
        send_email(@user.email, "BendroCorp - Forgotten Password", "<h1>Forgot Your Password..?</h1><p>No worries. Just click the link below and you will be able to reset your password.</p><br /><p><a href=\'http://localhost:4200/password-reset/#{new_token}\'>Password Reset</a></p>")
      end
    end

    # we reply with the same thing no matter what
    render status: 200, json: { message: "If your email exists in our system you will receive an email with intructions on how to reset your password shortly." }
  end

  # POST /api/account/reset-password
  # Must contained [:user][:password|:password_confirmation]
  def forgot_password_complete
    #
    @user = User.find_by password_reset_token: params[:user][:password_reset_token]

    if @user != nil && @user.login_allowed
      @user.update_attributes(reset_params)
      @user.password_reset_token = nil
      @user.password_reset_requested = false
      if @user.save
        render status: 200, json: { message: "Password reset successful. Please login below." }
      else
        render status: 500, json: { message: "Password reset could not be completed because: #{@user.errors.full_messages.to_sentence}" }
      end
    else
      render status: 500, json: { message: "Either this user does not exist or no forgot password request was submitted." }
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

  # DELETE api/account/token/:token
  def remove_user_token
    @token = UserToken.where(user: current_user, token: params[:token])
    if @token
      if @token.destroy
        render status: 200, json: { message: 'Token removed!' }
      else
        render status: 500, json: { message: "The token could not be removed because: #{@token.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Token not found. It may have already been removed.' }
    end
  end

  def fetch_user_countries
    render status: 200, json: { user_countries: UserCountry.all.order('title') }
  end

  private
  def reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  private
  def forgot_params
    params.require(:user).permit(:email)
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
