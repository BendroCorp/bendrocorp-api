class SiteLogController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action only: [:list] do |a|
    a.require_one_role([39])
  end

  # GET api/site-log
  def list
    render status: 200, json: SiteLog.all.as_json(include: { site_log_type: { } })
  end
end
