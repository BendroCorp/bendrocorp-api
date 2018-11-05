class AdminController < ApplicationController
  before_action :require_user
  before_action :require_member

  before_action only: [:impersonate] do |a|
    a.require_one_role([32])
  end

  before_action only: [:fetch_users, :fetch_approval_kinds] do |a|
    a.require_one_role([33])
  end

  # GET api/admin/users
  def fetch_users
    render status: 200, json: { users: User.where('id NOT IN (?)', [current_user.id, 0]).order('username').as_json(only: [:id, :username]),  message: 'User list fetched' }
  end

  # GET api/admin/approval-kinds
  def fetch_approval_kinds
    render status: 200, json: { approval_kinds: ApprovalKind.all.as_json(include: { roles: { } } ) }
  end

  # GET api/admin/impersonate/:impersonate_user_id
  def impersonate
    @user = User.find_by_id(params[:impersonate_user_id].to_i)

    if @user != nil
      # Get the number of people in the role for the email notification
      impersonate_role_count = Role.find_by_id(32).role_users.count

      # email the user
      email_message = "One of our administrators, #{current_user.username}, is currently using our administrative feature which allows someone to fully impersonate you on the BendroCorp website. <p>This is typically done to fix technical issues on the website that cannot be resolved via logging or other means.</p><p>Our policy states that an administrator must request your permission to impersonate you on our site. If this did not occur please directly notify the CEO. There are currently only #{impersonate_role_count} user(s) who have this ability.</p><p>You will recieve this notification any time this feature is used by an administrator of BendroCorp.</p>"
      send_email(@user.email, 'Admin Impersonation Notification', email_message)

      # create a new token for the user
      new_token = UserToken.new(token: token_text, device: "Impersonation", expires: Time.now + 2.hours)
      @user.user_tokens << new_token

      # save back the user
      if @user.save
        SiteLog.create(module: 'Admin', submodule: 'Impersonation', message: "User ##{@user.id} successfully impersonated!", site_log_type_id: 1)
        puts
        puts "User impersonated and token created!"
        puts
        render status: 200, json: { id: @user.id, character: @user.main_character.as_json(only: [:id, :first_name, :last_name], methods: [:full_name, :avatar_url, :current_job]), tfa_enabled: @user.use_two_factor, token: token_text, token_expires: new_token.expires_ms, claims: @user.claims }
      else
        render status: 500, json: { message: "Login was not successful because: #{@user.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'User was not found' }
    end
  end
end
