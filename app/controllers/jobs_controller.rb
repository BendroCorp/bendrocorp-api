class JobsController < ApplicationController
  before_action :require_user, except: [:list_hiring]
  before_action :require_member, except: [:list_hiring]

  # GET api/job
  def list
    render status: 200, json: Job.all.order('title')
  end

  # GET api/job/hiring
  def list_hiring
    render status: 200, json: Job.where('hiring = ?', true).order('title')
  end
end
