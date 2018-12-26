class JobsController < ApplicationController
  before_action :require_user, except: [:list_hiring]
  before_action :require_member, except: [:list_hiring]
  before_action only: [:create, :update] do |a|
    a.require_one_role([38])
  end

  # GET api/job
  def list
    render status: 200, json: Job.all.order('title')
  end

  # GET api/job/hiring
  def list_hiring
    render status: 200, json: Job.where('hiring = ?', true).order('title')
  end

  # GET api/job/types
  def job_types
    render status: 200, json: JobLevel.all.order('id desc')
  end

  # POST api/job
  def create
    @job = Job.new(job_params)
    if @job.save
      render status: 201, json: @job
    else
      render status: 500, json: { message: "Job could not be created because: #{@job.errors.full_messages.to_sentence}" }
    end
  end

  # PATCH api/job
  def update
    @job = Job.find_by_id(params[:job][:id].to_i)
    if @job
      if @job.update_attributes(job_params)
        render status: 201, json: @job
      else
        render status: 500, json: { message: "Job could not be created because: #{@job.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Job not found!' }
    end
  end

  def job_params
    params.require(:job).permit(:title, :description, :division_id, :hiring, :job_level_id)
  end
end
