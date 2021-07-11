class IncidentReportsController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action :set_current_user_is_security
  before_action :set_incident_report, only: [:show, :update, :destroy, :add_comment, :approve_report, :decline_report]
  before_action :set_incident_report_comment, only: [:remove_comment]

  # status guid
  NOT_STARTED_GUID = 'a067e0d6-018e-4afc-87c9-6c486c512a76'
  PENDING_GUID = 'd593a55f-86fd-4cfa-88ce-1b8e38737c8c'
  APPROVED_GUID = 'f4619ce3-2d7e-41cd-9286-7f889e8f17b6'
  DECLINED_GUID = 'd9bbda83-e290-4b0c-88ff-1e15ab674640'

  before_action only: [:destroy] do |a|
    a.require_one_role([2]) # executive
  end

  before_action only: [:index, :add_comment, :remove_comment, :approve_report, :decline_report] do |a|
    a.require_one_role([5]) # security
  end

  # GET api/incident
  def index
    @incident_reports = IncidentReport.where(archived: false) # .where.not(approval_status_id: NOT_STARTED_GUID)

    render json: @incident_reports.as_json(include: { infractions: {}, intelligence_case: { only: [:id], include: { assigned_to: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url]  } } }, approval_status: {}, comments: { include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } } }, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, star_object: {}, force_used: {}, ship_used: {} })

    @incident_reports.each do |report|
      UpdateIntelCaseHandleAvatarJob.perform_later(report)
    end
  end

  # GET api/incident/my
  def index_mine
    @incident_reports = IncidentReport.where(archived: false, created_by_id: current_user.id).order(created_at: :desc)
    render json: @incident_reports.as_json(include: { infractions: {}, intelligence_case: { only: [:id], include: { assigned_to: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url]  } } }, approval_status: {}, comments: { include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } } }, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, star_object: {}, force_used: {}, ship_used: {} })

    # fire this up in the background
    @incident_reports.each do |report|
      UpdateIntelCaseHandleAvatarJob.perform_later(report)
    end
  end

  # GET api/incident/assigned
  def index_assigned
    # var
    @incident_reports = []

    # get the ones we want
    IntelligenceCase.where(assigned_to_id: current_user.id, archived: false).each do |intel_case|
      @incident_reports << (incident_reports << intel_case.incident_reports).flatten! 
    end

    # return the results
    render json: @incident_reports.as_json(include: { infractions: {}, intelligence_case: { only: [:id], include: { assigned_to: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url]  } } }, approval_status: {}, comments: { include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } } }, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, star_object: {}, force_used: {}, ship_used: {} })
  end

  # GET api/incident/1
  def show
    # security
    # TODO: Eventually we may give incident reports a classification
    unless @incident_report.created_by_id == current_user.id || @is_security
      render status: 403, json: { message: 'You lack the required access to directly view this incident report!' }
    end

    # return val
    render json: @incident_report.as_json(include: { infractions: {}, intelligence_case: { only: [:id], include: { assigned_to: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url]  } } }, approval_status: {}, comments: { include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } } }, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, star_object: {}, force_used: {}, ship_used: {} })
  end

  # POST api/incident
  def create
    IncidentReport.transaction do
      @incident_report = IncidentReport.new(incident_report_params)
      @incident_report.created_by_id = current_user.id
      # handle infractions
      # Handle adding the intial infractions from params[:incident_report][:infractions]
      params[:incident_report][:infractions].to_a.each do |infraction|
        found_infraction = IncidentReportInfraction.find_by_id(infraction[:id].to_i)
        @incident_report.incident_report_infractions << IncidentReportInfraction.new(infraction: found_infraction) if found_infraction
      end

      # properly assign occured_when
      if params[:incident_report][:occured_when_ms]
        @incident_report.occured_when = Time.at(params[:incident_report][:occured_when_ms].to_f / 1000)
      end

      # if submitted for approval, adjust the status to pending
      if params[:incident_report][:submit_for_approval] && params[:incident_report][:submit_for_approval] == true
        if @is_security
          @incident_report.approval_status_id = APPROVED_GUID
        else
          @incident_report.approval_status_id = PENDING_GUID
        end
      end

      # save in the incident report
      if @incident_report.save
        if @incident_report.approval_status_id == PENDING_GUID
          PushWorker.perform_async(@incident_report.intelligence_case.assigned_to.id, "#{@incident_report.created_by.main_character_full_name} has submitted an incident report for review!")
        end
        render json: @incident_report.as_json(include: { infractions: {}, intelligence_case: { only: [:id], include: { assigned_to: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url]  } } }, approval_status: {}, comments: { include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } } }, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, star_object: {}, force_used: {}, ship_used: {} })
      else
        render json: { message: @incident_report.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT api/incident/1
  def update
    IncidentReport.transaction do
      # guard to make sure that the report is not started or approved
      if @incident_report.approval_status_id == PENDING_GUID || @incident_report.approval_status_id == APPROVED_GUID
        render status: :unprocessable_entity, json: { message: 'Cannot update a report which is pending or approved' }
        return
      end

      # make sure you have edit rights on the report
      # make this the assigned officer or admin or creator only
      unless current_user.is_in_role(55) || @incident_report.intelligence_case.assigned_to == current_user.id || @incident_report.created_by_id == current_user.id
        render status: :unprocessable_entity, json: { message: 'You do not have the rights update this incident report!' }
      end

      # properly assign occured_when
      if params[:incident_report][:occured_when_ms]
        @incident_report.occured_when = Time.at(params[:incident_report][:occured_when_ms].to_f / 1000)
      end

      # handle infractions
      # update the infractions
      if params[:incident_report][:infractions]
        original_infractions = @incident_report.infractions.map { |item| item.id }
        updated_infractions = params[:incident_report][:infractions].map { |item| item[:id] }

        # remove old infractions
        @incident_report.incident_report_infractions.where(infraction_id: (original_infractions - updated_infractions)).delete_all

        # add infraction items
        (updated_infractions - original_infractions).each do |add_infraction_id|
          found_infraction = FieldDescriptor.find_by_id(add_infraction_id)
          @incident_report.incident_report_infractions << IncidentReportInfraction.new(infraction: found_infraction) if found_infraction
        end
      end

      # if submitted for approval, adjust the status to pending
      if params[:incident_report][:submit_for_approval] && params[:incident_report][:submit_for_approval] == true
        if @is_security
          @incident_report.approval_status_id = APPROVED_GUID
        else
          @incident_report.approval_status_id = PENDING_GUID
        end
      end

      # update the incident report
      if @incident_report.update(incident_update_report_params)
        if @incident_report.approval_status_id == PENDING_GUID
          PushWorker.perform_async(@incident_report.intelligence_case.assigned_to.id, "#{@incident_report.created_by.main_character_full_name} has submitted an incident report for review!")
        end
        render json: @incident_report.as_json(include: { infractions: {}, intelligence_case: { only: [:id], include: { assigned_to: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url]  } } }, approval_status: {}, comments: { include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } } }, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, star_object: {}, force_used: {}, ship_used: {} })
      else
        render json: { message: @incident_report.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end
  end

  # DELETE api/incident/1
  def destroy
    @incident_report.archive = true

    if @incident_report.save
      render json: { message: 'Incident report archived!' }
    else
      render json: { message: @incident_report.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # GET api/incident/1/approve
  def approve_report
    # must be admin or the assigned officer
    unless current_user.is_in_role(55) || @incident_report.intelligence_case.assigned_to_id == current_user.id
      render status: :unprocessable_entity, json: { message: 'You are not authorized to approve this incident report!' }
    end

    if @incident_report.approval_status_id == 'd593a55f-86fd-4cfa-88ce-1b8e38737c8c' # pending

      # TODO: Add who approved it

      @incident_report.approval_status_id = 'f4619ce3-2d7e-41cd-9286-7f889e8f17b6' # approved
      if @incident_report.save
        # notify end user
        PushWorker.perform_async(@incident_report.created_by_id, "Your incident report has been approved.")

        # result
        render json: { message: 'Report approved!' }
      else
        render status: :unprocessable_entity, json: { message: @incident_report.errors.full_messages.to_sentence }
      end
    else
      render status: :unprocessable_entity, json: { message: 'Cannot approve a report which is not pending' }
    end
  end

  # GET api/incident/1/decline
  def decline_report
    # must be admin or the assigned officer
    unless current_user.is_in_role(55) || @incident_report.intelligence_case.assigned_to_id == current_user.id
      render status: :unprocessable_entity, json: { message: 'You are not authorized to decline this incident report!' }
    end

    if @incident_report.approval_status_id == 'd593a55f-86fd-4cfa-88ce-1b8e38737c8c' # pending

      # TODO: Add who declined it

      @incident_report.approval_status_id = 'd9bbda83-e290-4b0c-88ff-1e15ab674640' # declined
      if @incident_report.save
        # notify end user
        PushWorker.perform_async(@incident_report.created_by_id, 'Your incident report has been declined. Please check the comments for more details.')

        # result
        render json: { message: 'Report approved!' }
      else
        render status: :unprocessable_entity, json: { message: @incident_report.errors.full_messages.to_sentence }
      end
    else
      render status: :unprocessable_entity, json: { message: 'Cannot decline a report which is not pending' }
    end
  end

  # api/incident/:id/comment
  def add_comment
    # create the object
    @incident_report_comment = IncidentReportComment.new(incident_report_comment_params)

    # set needed vars
    @incident_report_comment.incident_report_id = @incident_report.id
    @incident_report_comment.created_by_id = current_user.id

    # save it back
    if @incident_report_comment.save
      render status: :created, json: { message: 'Comment added!' }
    else
      render status: :unprocessable_entity, json: { message: @incident_report_comment.errors.full_messages.to_sentence }
    end
  end

  # api/incident/:id/comment/:comment_id
  def remove_comment
    if @incident_report_comment.destroy
      render json: { message: 'Comment removed!' }
    else
      render status: :unprocessable_entity, json: { message: @incident_report_comment.errors.full_messages.to_sentence }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incident_report
      if params[:id] && params[:id].match(/^(?!.*--)[A-Za-z0-9-]*$/) # _- removed these for now
        clause = "id::text LIKE ? AND archived = false", "#{params[:id]}%"
        @incident_report = IncidentReport.where(clause).first

        UpdateIntelCaseHandleAvatarJob.perform_later(@incident_report) unless @incident_report.nil?
      end

      if @incident_report.nil?
        render status: 404, json: { message: 'Incident report not found or is not available to you!' }
        return
      end
    end

    def set_incident_report_comment
      if params[:comment_id] && params[:comment_id].match(/^(?!.*--)[A-Za-z0-9-]*$/) # _- removed these for now
        clause = "id::text LIKE ? AND archived = false", "#{params[:comment_id]}%"
        @incident_report_comment = IncidentReportComment.where(clause).first
      end

      if @incident_report.nil?
        render status: 404, json: { message: 'Incident report not found or is not available to you!' }
        return
      end
    end

    def set_current_user_is_security
      @is_security = current_user.is_in_role(54)
    end

    # Only allow a list of trusted parameters through.
    def incident_report_params
      if @is_security
        params.require(:incident_report).permit(:description, :rsi_handle, :occured_when, :star_object_id, :accepted, :force_used_id, :ship_used_id, :violence_rating_id)
      else
        params.require(:incident_report).permit(:description, :rsi_handle, :occured_when, :star_object_id, :force_used_id, :ship_used_id)
      end
    end

    def incident_update_report_params
      if @is_security
        params.require(:incident_report).permit(:description, :occured_when, :star_object_id, :force_used_id, :ship_used_id, :violence_rating_id)
      else
        params.require(:incident_report).permit(:description, :occured_when, :star_object_id, :force_used_id, :ship_used_id)
      end
    end

    def incident_report_comment_params
      params.require(:incident_report_comment).permit(:comment)
    end
end
