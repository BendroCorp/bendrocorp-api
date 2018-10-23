class ApprovalKindController < ApplicationController
  before_action :require_user
  before_action :require_member

  before_action except: [] do |a|
    a.require_one_role([33])
  end

  # GET api/approval-kinds
  def list
    render status: 200, json: { approval_kinds: ApprovalKind.all.as_json(include: { roles: { methods: [:role_users] } } ) }
  end
end
