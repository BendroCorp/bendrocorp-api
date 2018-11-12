class UsersController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action except: [:list] do |a|
    a.require_one_role([2])
  end

  # GET api/user
  def list
    render status: 200, json: User.where('id <> 0').as_json(only: [:id, :username, :rsi_handle], include: { roles: { include: { nested_roles: { include: { role_nested: { } } } } } }, methods: [:main_character])
  end

  # GET api/user/me
  def me
    render status: 200, json: current_user.as_json(only: [:id, :email], include: { roles: { include: { nested_roles: { include: { role_nested: { } } } } } }, methods: [:main_character])
  end

  # GET api/user/approvals
  def approvals
    render status: 200, json: current_user.approval_approvers.order('created_at desc').as_json(include: { approval_type: { }, approval: { methods: [:approval_status, :approval_link, :approval_source_requested_item, :approval_source, :approval_source_character_name, :approval_source_on_behalf_of], include: { approval_kind: { }, approval_approvers: { methods: [:character_name, :approver_response], include: { approval_type: { } } } } } })
  end

  # GET api/user/approvals-count
  def approvals_count
    render status: 200, json: current_user.approval_approvers.where('approval_type_id < 4').count
  end

  # GET api/user/oauth-tokens
  def oauth_tokens
    render status: 200, json: OauthToken.where(user: current_user).as_json(methods: [:client_title])
  end

  # POST api/user/push-token
  # Must contain token and user_device_type_id (1 = iOS, 2(TODO) = Amazon)
  def add_push_token
    if params[:token] && params[:user_device_type_id]
      device_type = UserDeviceType.find_by_id(params[:user_device_type_id].to_i)
      if device_type
        current_user.user_push_tokens << UserPushToken.new(token: params[:token], user_device_type: device_type)
        if current_user.save
          render status: 200, json: { message: 'Device token added!' }
        else
          render status: 500, json: { message: "A push token could not be added because: #{current_user.errors.full_messages.to_sentence}" }
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
end
