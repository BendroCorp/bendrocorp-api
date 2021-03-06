class SessionsController < ApplicationController
  # POST /auth
  # Non-oauth method this requires you to have the users password and email to create a token
  # The created token will be full scope
  def auth
    # regular password grant
    if params[:session] && (!params[:session][:grant_type] || params[:session][:grant_type] == 'password') && params[:session][:email] && params[:session][:password] && params[:session][:device]
      @user = User.find_by email: params[:session][:email].to_s.downcase
      # Does the user exist?
      if @user != nil
        if !@user.locked && @user.login_allowed && @user.active
          if @user.authenticate(params[:session][:password]) && (!@user.locked && @user.login_allowed) && (!@user.use_two_factor || (@user.use_two_factor && @user.two_factor_valid(params[:session][:code])))
            # create the jwt token
            allow_offline_access = true if params[:session][:offline_access] && params[:session][:offline_access] == true
            allow_offline_access = false if !allow_offline_access

            jwt_bundle = make_jwt(@user, allow_offline_access)

            @user.user_sessions << UserSession.new(ip_address: request.remote_ip)
            @user.user_tokens << UserToken.new(token: jwt_bundle[:refresh_token], device: params[:session][:device], expires: Time.now + 2.years, ip_address: request.remote_ip) if allow_offline_access

            @user.login_attempts = 0
            if @user.save
              SiteLog.create(module: 'Session', submodule: 'Success', message: "User ##{@user.id} successfully authenticated!", site_log_type_id: 1)
              render status: 200, json: jwt_bundle
            else
              SiteLog.create(module: 'Session', submodule: 'User Save on Success Fail', message: "User could not be saved because: #{@user.errors.full_messages.to_sentence}", site_log_type_id: 1)
              render status: 500, json: { message: "Login was not successful because: #{@user.errors.full_messages.to_sentence}" }
            end
          # if the auth fails
          else
            # if the account is not already locked
            unless @user.locked
              @user.login_attempts += 1
              # if threshold exceeded then lock the account
              @user.locked = true if @user.login_attempts >= 5

              if @user.save
                # if we locked the account then notify the user
                if @user.locked
                  # email the user
                  SiteLog.create(module: 'Session', submodule: 'Account Lockout', message: "#{@user.email} has been locked out because of too many password attempts.", site_log_type_id: 1)
                  send_email @user.email, "Account Lockout", "<div><p><h3>Account Lockout</h3></p><p>It looks like there is a security issue with your account. Please contact an admin on Discord to start the unlock process.</p></div>"
                end
              else
              SiteLog.create(module: 'Session', submodule: 'Lockout Save Failure', message: "Lockout or attempt incrementation could not be saved because: #{@user.errors.full_messages.to_sentence}", site_log_type_id: 1)
              # render status: 500, json: { message: "Error occured while trying to access user data."}
              end
            end
            SiteLog.create(module: 'Session', submodule: 'Auth Failure', message: "User ##{@user.id} could not authenticated. Authorization failed. #{params[:session][:code]}", site_log_type_id: 1)
            render status: 404, json: { message: "User not found or incorrect credentials were provided." }
          end
        else
          SiteLog.create(module: 'Session', submodule: 'Account Locked', message: "User ##{@user.id} could not authenticated. Account is locked.", site_log_type_id: 1)
          render status: 404, json: { message: 'User not found or incorrect credentials were provided.' }
        end
      else
        SiteLog.create(module: 'Session', submodule: 'User does not exist', message: "User could not authenticated. User does not exist! Used: #{params[:session][:email]}", site_log_type_id: 1)
        render status: 404, json: { message: 'User not found or incorrect credentials were provided.' }
      end
    # dealing with a refresh_token
    elsif params[:session] && params[:session][:grant_type] && params[:session][:grant_type] == 'refresh_token' && params[:session][:refresh_token]
      user_token = UserToken.find_by(token: params[:session][:refresh_token])
      if user_token && user_token.user && !user_token.is_expired
        # make sure that the user is not grounded
        if !user_token.user.locked && user_token.user.login_allowed && user_token.user.active
          # user
          user = user_token.user

          # create user session
          user.user_sessions << UserSession.new(ip_address: request.remote_ip)

          # create the bundle
          jwt_bundle = make_jwt(user_token.user, true, true)

          # store the bundle result
          user.user_tokens << UserToken.new(token: jwt_bundle[:refresh_token], device: user_token.device, expires: Time.now + 2.years, ip_address: request.remote_ip)

          # remove the old refresh token
          user_token.destroy

          if user.save
            # return the results
            render status: 201, json: jwt_bundle
          else
            render json: { message: user.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        else
          # if the user account is locked out for whatever reason then trash all of their refresh_tokens
          user_token.user.user_tokens.destroy_all
          render status: 404, json: { message: 'Refresh token not found, is expired or the account is unavailable.' } 
        end
      else
        render status: 404, json: { message: 'Refresh token not found, is expired or the account is unavailable.' }
      end
    else
      SiteLog.create(module: 'Session', submodule: 'Bad Object', message: "Session object badly formed or not provided. #{params.inspect}", site_log_type_id: 1)
      render status: 400, json: { message: 'Session object not provided or not properly created. Please see API documentation.' }
    end
  end
end
