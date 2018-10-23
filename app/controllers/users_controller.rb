class UsersController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action except: [:me, :approvals, :approvals_count] do |a|
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
end
