class UsersController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action only: [:list] do |a|
    a.require_one_role([2])
  end

  # GET api/user
  def list
    render status: 200, json: User.where('id <> 0').as_json(only: [:id, :username, :rsi_handle], include: { roles: { include: { nested_roles: { include: { role_nested: { } } } } } }, methods: [:main_character])
  end

  # GET api/user/me | /userinfo
  def me
    render status: 200, json: current_user.db_user.as_json(only: [:id, :email], include: { discord_identity: { }, roles: { include: { nested_roles: { include: { role_nested: { } } } } } }, methods: [:main_character])
  end

  # GET api/user/approvals
  # GET api/user/approvals/:count
  # GET api/user/approvals/:count/:skip
  def approvals
    approvals_list = []
    if params[:count]
      if params[:skip]
        approvals_list = current_user.db_user.approval_approvers.order('created_at desc').offset(params[:skip].to_i).take(params[:count].to_i)
      else
        approvals_list = current_user.db_user.approval_approvers.order('created_at desc').take(params[:count].to_i)
      end
    else
      approvals_list = current_user.db_user.approval_approvers.order('created_at desc')
    end

    # make sure we are only fetching bound approvals
    approvals_list = approvals_list.to_a.select { |approver| approver.approval.is_bound? }
    # return final approvals_list
    render status: 200, json: approvals_list.as_json(include: { approval_type: { }, approval: { methods: [:approval_status, :approval_link, :approval_source_requested_item, :approval_source, :approval_source_character_name, :approval_source_on_behalf_of], include: { approval_kind: { }, approval_approvers: { methods: [:character_name, :approver_response], include: { approval_type: { } } } } } })
  end

  # GET api/user/approval/:approval_approver_id
  def approval
    @aa = current_user.db_user.approval_approvers.find_by_id(params[:approval_approver_id].to_i)
    if @aa
      render status: 200, json: @aa.as_json(include: { approval_type: { }, approval: { methods: [:approval_status, :approval_link, :approval_source_requested_item, :approval_source, :approval_source_character_name, :approval_source_on_behalf_of], include: { approval_kind: { }, approval_approvers: { methods: [:character_name, :approver_response], include: { approval_type: { } } } } } })
    else
      render status: 404, json: { message: 'No approver record found for that id' }
    end
  end

  # GET api/user/approvals-count-total
  def approvals_count_total
    render status: 200, json: current_user.db_user.approval_approvers.count
  end

  # GET api/user/approvals-count
  def approvals_count
    render status: 200, json: current_user.db_user.approval_approvers.where('approval_type_id < 4').count
  end

  # GET api/user/oauth-tokens
  def oauth_tokens
    render status: 200, json: OauthToken.where(user_id: current_user.id).as_json(methods: [:client_title])
  end

  # GET api/user/auth-tokens
  def auth_tokens
    render status: 200, json: UserToken.where(user_id: current_user.id).order('created_at desc').as_json(methods: [:is_expired, :perpetual])
  end

  # POST api/user/discord-identity
  def discord_identity
    user = current_user.db_user
    if user.discord_identity
      user.discord_identity.discord_identity = DiscordIdentity.new(discord_id: params[:discord_identity][:discord_id])
    else
      user.discord_identity.discord_identity.discord_id = params[:discord_identity][:discord_id]
    end

    if user.save
      render status: 200, json: { message: 'Discord identity updated!' }
    else
      render status: 400, json: { message: "Discord identity could not be created or updated because: #{user.errors.full_messages.to_sentence}" }
    end
  end

  # POST api/user/push-token
  # Must contain token, user_device_type_id, reg_data (1 = iOS, 2(TODO) = Amazon)
  def add_push_token
    if params[:push_token] && params[:push_token][:token] && params[:push_token][:user_device_type_id] && params[:push_token][:reg_data]
      db_user = current_user.db_user
      device_type = UserDeviceType.find_by_id(params[:push_token][:user_device_type_id].to_i)
      if device_type
        db_user.user_push_tokens << UserPushToken.new(push_params)
        if db_user.save
          render status: 200, json: { message: 'Device token added!' }
        else
          render status: 500, json: { message: "A push token could not be added because: #{db_user.errors.full_messages.to_sentence}" }
        end
      else
        render status: 400, json: { message: 'Device type if not found!' }
      end
    else
      render status: 400, json: { message: 'Incorrect parameters provided or parameters missing.' }
    end
  end

  # GET api/user/push
  def push_self
    send_push_notification current_user.id, "This is a test. You sent this to your devices. :)"
    render status: 200, json: { message: 'Self push succeeded!' }
  end

  private
  def push_params
    params.require(:push_token).permit(:token, :user_device_type_id, :reg_data)
  end

  def discord_identity_params
    params.require(:discord_identity).permit(:discord_id, :discord_snowflake_id)
  end
end
