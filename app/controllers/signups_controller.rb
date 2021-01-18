class SignupsController < ApplicationController
  # POST api/signup
  def create
    @user = User.new(user_params)
    @user.verification_string = Digest::SHA256.hexdigest @user.email
    @user.email.downcase!

    if !HaveIBeenPwned::pwned params[:signup][:password]
      puts "Preparing to create user"
      @user.roles << Role.find_by_id(-1) # applicant role
      @user.roles << Role.find_by_id(-2) # client role
      if @user.save
        # email the verfification - we stopped sending verfication emails
        # send_email(@user.email, "BendroCorp Email Verification", "<h1>Welcome!</h1><p>Hey there #{@user.username}! Before we can let you apply to BendroCorp we need you to verify your email.</p><br /><p><a href=\'http://localhost:4200/verify/#{@user.verification_string}\'>Click Here to Verify</a></p><br />")
        send_email(@user.email, "Welcome! - BendroCorp", "<h1>Welcome!</h1><p>Hey there #{@user.username}! This is a confirmation that you have signed up for an account with BendroCorp.")
        render status: 200, json: { message: 'Your account was successfully created.' }
      else
        render status: 500, json: { message: "Your account could not be created because: #{@user.errors.full_messages.to_sentence}" }
      end
    else
      render status: 400, json: { message: 'This password is a common password and/or it was a part of a security breach and cannot be used on our service!' }
    end
  end

  # GET api/verification
  def resend_verification
    db_user = current_user.db_user
    if !db_user.email_verified
      send_email(db_user.email, "BendroCorp Email Verfification", "<h1>Welcome!</h1><p>Hey there #{db_user.username}! Before we can let you apply to BendroCorp we need you to verify your email.</p><br /><p><a href=\'http://localhost:4200/verify/#{@user.verification_string}\'>Click Here to Verify</a></p><br />")
      render status: 200, json: { message: '' }
    else
      render status: 400, json: { message: 'Your email has already been verified...' }
    end
  end

  # GET api/verify/:id
  def verify
    link = params[:id]
    if /^[a-z0-9]+$/.match(link) == nil
      render status: 400, json: { message: 'You have attempted to verify an account that does not exist or has already been verified.' }
    else
      @user = User.find_by verification_string: link
      if @user != nil
        if !@user.email_verified
          @user.email_verified = true
          if @user.save
            render status: 200, json: { message: 'Your account was successfully verified. Please login below.' }
          else
            render status: 500, json: { message: "There was an error saving your verfification because: #{user.errors.full_messages.to_sentence}" }
          end
        else
          render status: 400, json: { message: 'You have attempted to verify an account that does not exist or has already been verified.' }
        end
      else
        render status: 400, json: { message: 'You have attempted to verify an account that does not exist or has already been verified.' }
      end
    end
  end
end

private
def user_params
  params.require(:signup).permit(:username, :email, :password, :password_confirmation)
end
