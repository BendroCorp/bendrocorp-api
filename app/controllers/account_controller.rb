class AccountController < ApplicationController
  before_action :require_user, except: [:forgot_password, :forgot_password_complete]
  before_action :require_member, except: [:forgot_password, :forgot_password_complete]

  # POST /api/account/change-password
  # :password[original_password, password, password_confirmation]
  def change_password
    puts "Starting password change..."
    if params[:password] && params[:password][:password] && params[:password][:original_password] && params[:password][:password_confirmation]
      # all required params are present
      if current_user.db_user.authenticate(params[:password][:original_password])
        if !HaveIBeenPwned::pwned params[:password][:password]
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
            render status: 400, json: { message: 'Password and confirmation passwords do not match.' }
          end
        else
          render status: 400, json: { message: 'This password is a common password and/or it was a part of a security breach and cannot be used on our service!' }
        end
      else
        render status: 400, json: { message: 'Your original password seems to be incorrect. Please try again.' }
      end
    else
      render status: 400, json: { message: 'Request not properly formed. Request must include, original_password, password and password_confirmation contained within password object.'}
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
    db_user = current_user.db_user
    if !db_user.use_two_factor
      db_user.assign_auth_secret
      if db_user.save
        render status: 200, json: { qr_data_string: "otpauth://totp/bendrocorp?secret=#{db_user.auth_secret}", seed_value: db_user.auth_secret }
      else
        render status: 500, json: { message: 'Error Occured. Could not create auth secret'}
      end
    else
      render status: 403, json: { message: 'Two factor authentication is already enabled on this account' }
    end
  end

  # POST api/account/enable-tfa
  def enable_two_factor_auth
    db_user = current_user.db_user
    if db_user.authenticate(params[:two_factor_auth][:password])
      if db_user.two_factor_valid(params[:two_factor_auth][:code])
        @user = User.find_by_id(db_user.id)
        @user.use_two_factor = true
        if @user.save
          render status: 200, json: { message: 'Two factor authentication enabled!.' }
        else
          render status: 500, json: { message: "Two factor could not be enabled on this account because: #{db_user.errors.full_messages.to_sentence}" }
        end
      else
        render status: 403, json: { message: 'Incorrect code try again! Make sure to not include any spaces or dashes.'}
      end
    else
      render status: 403, json: { message: 'The password you entered was incorrect!' }
    end
  end

  def update_user_info
    db_user = current_user.db_user
    if db_user.user_information.update_attributes(user_info_params)
      render status: 200, json: { message: 'Personal information updated.' }
    else
      render status: 500, json: { message: 'Error Occured: Personal information could not be updated.' }
    end
  end

  # DELETE api/account/token/:token
  def remove_user_token
    @token = UserToken.find_by(user: current_user, token: params[:token])
    if @token
      if @token.destroy
        render status: 200, json: { message: 'Device removed!' }
      else
        render status: 500, json: { message: "The device token could not be removed because: #{@token.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Device token not found. It may have already been removed.' }
    end
  end

  def fetch_user_countries
    render status: 200, json: { user_countries: UserCountry.all.order('title') }
  end

  # POST api/account/update-email
  def update_email
    if params[:password] && params[:email]
      @user = User.find_by_id(current_user.id)
      if @user.authenticate(params[:password])
        original_email = @user.email
        @user.email = params[:email]
        if @user.save
          emailBody = "<div><p><h3>Email Change Notification</h3></p><p>Hey there #{@user.main_character.full_name},</p><p>It looks like you just updated your email from <strong>#{original_email}</strong> to <strong>#{@user.email}</strong> and this is a courtesy notification to let you know that that went through. This message has been sent to both your old and new email.</p><p>If you did not make this change please contact an administrator ASAP.</p></div>"
          send_email original_email, "Email Change Notification", emailBody
          send_email @user.email, "Email Change Notification", emailBody
          render status: 200, json: { message: 'Email updated!' }
        else
          render status: 500, json: { message: "Email could not be updated because: #{@user.errors.full_messages.to_sentence}." }
        end
      else
        @user.login_attempts += 1
        # if threshold exceeded then lock the account
        if @user.login_attempts >= 5
          @user.locked = true
        end
        if @user.save
          # if we locked the account then notify the user
          if @user.locked
            render status: 401, json: { message: "Account locked"}
            # TODO: email the user
            send_email @user.email, "Account Lockout", "<div><p><h3>Account Lockout</h3></p><p>It looks like there is a security issue with your account. Please contact an admin on Discord to start the unlock process.</p></div>"
          else
            render status: 400, json: { message: "Incorrect password provided!" }
          end
        else
          render status: 500, json: { message: "Error occured while trying to access user data."}
        end
      end
    else
      render status: 400, json: { message: "Password not provided." }
    end
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
