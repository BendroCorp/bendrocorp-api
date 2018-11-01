class SessionsController < ApplicationController
  # POST /auth
  # Non-oauth method this requires you to have the users password and email to create a token
  # The created token will be full scope
  def auth
   if params[:session] && params[:session][:email] && params[:session][:password] && params[:session][:device]
     @user = User.find_by email: params[:session][:email]
     # Does the user exist?
     if @user != nil
       if @user.authenticate(params[:session][:password]) && (!@user.use_two_factor || (@user.use_two_factor && @user.two_factor_valid(params[:session][:code]))) && (!@user.locked && @user.login_allowed && @user.active)
         # || (@user.use_two_factor && @user.two_factor_valid(params[:session][:code]))) && (!@user.locked && @user.login_allowed)
         # puts "User is authorized: #{@user && !@user.active && @user.authenticate(params[:session][:password]) && (!@user.use_two_factor || (@user.use_two_factor && @user.two_factor_valid(params[:session][:code]))) && (!@user.locked && @user.login_allowed)}"
         # puts "Creating token"
         token_text = make_token
         # token is not perpetual
         new_token = UserToken.new(token: token_text, device: params[:session][:device], expires: Time.now + 12.hours) if !params[:session][:perpetual]
         # token is perpetual
         new_token = UserToken.new(token: token_text, device: params[:session][:device]) if params[:session][:perpetual]
         @user.user_tokens << new_token
         @user.login_attempts = 0
         if @user.save
           puts
           puts "User authenticated and token created!"
           puts
           render status: 200, json: { id: @user.id, character: @user.main_character.as_json(only: [:id, :first_name, :last_name], methods: [:full_name, :avatar_url]), tfa_enabled: @user.use_two_factor, token: token_text, token_expires: new_token.expires_ms, claims: @user.claims }
         else
           render status: 500, json: { message: "Login was not successful because: #{@user.errors.full_messages.to_sentence}" }
         end
       # if the auth fails
       else
         # if the account is not already locked
         if !@user.locked
           @user.login_attempts += 1
           # if threshold exceeded then lock the account
           if @user.login_attempts >= 5
             @user.locked = true
           end
           if @user.save
             # if we locked the account then notify the user
             if @user.locked
               # TODO: email the user
               # send_email @user.email, "Account Lockout", "<div><p><h3>Account Lockout</h3></p><p>It looks like there is a security issue with your account. Please reply to this email to start the unlock process.</p></div>"
             end
           else
             render status: 500, json: { message: "Error occured while trying to access user data."}
           end
         end
         render status: 403, json: { message: "User not found or incorrect credentials were provided." }
       end
     else
       render status: 403, json: { message: 'User not found or incorrect credentials were provided.' }
     end
   else
     render status: 400, json: { message: 'Session object not provided or not properly created.' }
   end
  end
end
