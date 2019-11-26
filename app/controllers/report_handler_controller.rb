class ReportHandlerController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action except: [:index] do |a|
    a.require_one_role([48]) # report builder
  end

  # GET /reports/templates/handlers
  def index
    render json: ReportHandler.all.as_json(include: { variables: { } })
  end
end
