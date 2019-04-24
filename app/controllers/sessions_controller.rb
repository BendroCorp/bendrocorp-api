class SessionsController < ApplicationController
  # POST /auth
  # Non-oauth method this requires you to have the users password and email to create a token
  # The created token will be full scope
  def auth
   if params[:session] && params[:session][:email] && params[:session][:password] && params[:session][:device]
     @user = User.find_by email: params[:session][:email].to_s.downcase
     # Does the user exist?
     if @user != nil
       if !@user.locked && @user.login_allowed && @user.active
         if @user.authenticate(params[:session][:password]) && (!@user.use_two_factor || (@user.use_two_factor && @user.two_factor_valid(params[:session][:code])))
           # || (@user.use_two_factor && @user.two_factor_valid(params[:session][:code]))) && (!@user.locked && @user.login_allowed)
           # puts "User is authorized: #{@user && !@user.active && @user.authenticate(params[:session][:password]) && (!@user.use_two_factor || (@user.use_two_factor && @user.two_factor_valid(params[:session][:code]))) && (!@user.locked && @user.login_allowed)}"
           # puts "Creating token"
           token_text = make_token
           # token is not perpetual
           new_token = UserToken.new(token: token_text, device: params[:session][:device], expires: Time.now + 24.hours) if !params[:session][:perpetual]
           # token is perpetual
           new_token = UserToken.new(token: token_text, device: params[:session][:device]) if params[:session][:perpetual]
           @user.user_tokens << new_token
           @user.login_attempts = 0
           if @user.save
             SiteLog.create(module: 'Session', submodule: 'Success', message: "User ##{@user.id} successfully authenticated!", site_log_type_id: 1)
             puts
             puts "User authenticated and token created!"
             puts
             render status: 200, json: { id: @user.id, character: @user.main_character.as_json(only: [:id, :first_name, :last_name], methods: [:full_name, :avatar_url, :current_job]), tfa_enabled: @user.use_two_factor, token: token_text, token_expires: new_token.expires_ms, claims: @user.claims }
           else
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
                 send_email @user.email, "Account Lockout", "<div><p><h3>Account Lockout</h3></p><p>It looks like there is a security issue with your account. Please contact an admin on Discord to start the unlock process.</p></div>"
               end
             else
               render status: 500, json: { message: "Error occured while trying to access user data."}
             end
           end
           SiteLog.create(module: 'Session', submodule: 'Auth Failure', message: "User ##{@user.id} could not authenticated. Authorization failed.", site_log_type_id: 1)
           render status: 403, json: { message: "User not found or incorrect credentials were provided." }
         end
       else
         SiteLog.create(module: 'Session', submodule: 'Account Locked', message: "User ##{@user.id} could not authenticated. Account is locked.", site_log_type_id: 1)
         render status: 403, json: { message: 'User not found or incorrect credentials were provided.' }
       end
     else
       SiteLog.create(module: 'Session', submodule: 'User does not exist', message: "User could not authenticated. User does not exist! Used: #{params[:session][:email]}", site_log_type_id: 1)
       render status: 403, json: { message: 'User not found or incorrect credentials were provided.' }
     end
   else
     render status: 400, json: { message: 'Session object not provided or not properly created.' }
   end
  end
end
