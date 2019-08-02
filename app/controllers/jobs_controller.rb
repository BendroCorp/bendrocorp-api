class JobsController < ApplicationController
  before_action :require_user, except: [:list_hiring]
  before_action :require_member, except: [:list_hiring]
  before_action only: [:create, :update] do |a|
    a.require_one_role([38])
  end

  # GET api/job
  def list
    render status: 200, json: Job.all.order('title').as_json(methods: [:max_hired])
  end

  # GET api/job/hiring
  def list_hiring
    jobs = []
    Job.where('hiring = ?', true).order('title').each do |job|
      jobs << job if !job.max_hired
    end
    render status: 200, json: jobs
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
    if @job && !@job.read_only
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
    params.require(:job).permit(:title, :description, :hiring_description, :division_id, :hiring, :job_level_id, :max, :checks_max_headcount_from_id)
  end
end
