class DivisionsController < ApplicationController
  before_action :require_user, except: []
  before_action :require_member, except: []

  # GET api/divisions
  def list
    render status: 200, json: Division.all.order('ordinal')
  end
end
