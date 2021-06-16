class IntelligenceCasesController < ApplicationController
  before_action :set_intelligence_case, only: [:show, :update, :destroy]
  before_action :set_intelligence_case_comment, only: [:delete_comment]
  before_action :require_user
  before_action :require_member

  # reader
  before_action only: [:index, :show] do |a|
    a.require_one_role([53])
  end

  # admin only
  before_action except: [:index, :show, :destroy] do |a|
    a.require_one_role([54])
  end

  before_action only: [:destroy] do |a|
    a.require_one_role([55])
  end

  # GET api/intel
  def index
    @intelligence_cases = IntelligenceCase.where(archived: false).order(created_at: :desc).select do |intel_case|
      intel_case if intel_case.classification_level_id && current_user.db_user.classification_check(intel_case.classification_level_id)
    end

    render json: @intelligence_cases.as_json(methods: [:pending_incident_report_count], include: { warrants: {}, assigned_by: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, assigned_to: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, comments: {}, incident_reports: { include: { approval_status: {} } }, threat_level: {}, classification_level: {}, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } })
  end

  # GET api/intel/officers
  def list_assignable_officers
    # main_character_full_name
    role = Role.find_by_id(54)
    render json: role.role_full_users.as_json(only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] )
  end

  # GET api/intel/1
  def show
    if @intelligence_case.nil? || !current_user.db_user.classification_check(@intelligence_case.classification_level)
      render status: 404, json: { message: 'Intel case not found!' }
      return
    end

    render json: @intelligence_case.as_json(methods: [:pending_incident_report_count], include: { warrants: {}, assigned_by: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, assigned_to: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, incident_reports: { include: { infractions: {}, intelligence_case: { only: [:id] }, approval_status: {}, comments: { include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } } }, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, star_object: {}, force_used: {}, ship_used: {} } }, threat_level: {}, classification_level: {}, comments: { include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } } }, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } })

    UpdateIntelCaseHandleAvatarJob.perform_later(@intelligence_case)
  end

  # POST api/intel
  def create
    @intelligence_case = IntelligenceCase.new(intelligence_case_params)

    # set created by
    @intelligence_case.created_by_id = current_user.id

    # assign the case if the ui didn't assign it
    # if we are creating from this endpoint then we know that the user is in security
    if @intelligence_case.assigned_to_id.nil?
      @intelligence_case.assigned_to_id = current_user.id
      @intelligence_case.assigned_by_id = current_user.id
    end

    # save it
    if @intelligence_case.save
      UpdateIntelCaseHandleAvatarJob.perform_later(@intelligence_case)
      render status: :created, json: @intelligence_case.as_json(methods: [:pending_incident_report_count], include: { warrants: {}, assigned_by: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, assigned_to: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, incident_reports: { include: { infractions: {}, intelligence_case: { only: [:id], include: { assigned_to: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url]  } } }, approval_status: {}, comments: { include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } } }, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, star_object: {}, force_used: {}, ship_used: {} } }, threat_level: {}, classification_level: {}, comments: { include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } } }, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } })
    else
      render json: { message: @intelligence_case.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT api/intel/1
  def update
    # nil check
    if @intelligence_case.nil? || !current_user.db_user.classification_check(@intelligence_case.classification_level)
      render status: 404, json: { message: 'Intel case not found!' }
      return
    end

    # make sure you have edit rights on the report
    # make this the assigned officer or admin or creator only
    unless current_user.is_in_role(55) || @incident_report.intelligence_case.assigned_to == current_user.id
      render status: :unprocessable_entity, json: { message: 'You do not have the rights update this case!' }
    end

    # guard to make sure only admins can change the classification level
    if !current_user.is_in_role(55)
      # basically just override any potential attempted change with the original value
      params[:intelligence_case][:classification_level_id] = @intelligence_case.classification_level_id
      params[:intelligence_case][:assigned_to_id] = @intelligence_case.assigned_to_id
    end

    # update the object
    if @intelligence_case.update(intelligence_case_update_params)
      UpdateIntelCaseHandleAvatarJob.perform_later(@intelligence_case)
      render json: @intelligence_case.as_json(methods: [:pending_incident_report_count], include: { warrants: {}, assigned_by: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, assigned_to: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, incident_reports: { include: { infractions: {}, intelligence_case: { only: [:id], include: { assigned_to: {  only: [:id], methods: [:main_character_full_name, :main_character_avatar_url]  } } }, approval_status: {}, comments: { include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } } }, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }, star_object: {}, force_used: {}, ship_used: {} } }, threat_level: {}, classification_level: {}, comments: { include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } } }, created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } })
    else
      render json: { message: @intelligence_case.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # DELETE api/intel/1
  def destroy
    # nil check
    if @intelligence_case.nil? || !current_user.db_user.classification_check(@intelligence_case.classification_level)
      render status: 404, json: { message: 'Intel case not found!' }
    end

    # archived
    @intelligence_case.archived = true

    # save it
    if @intelligence_case.save
      render json: { message: 'Case archived!' }
    else
      render status: :unprocessable_entity, json: { message: 'Case could not be archived' }
    end
  end

  # POST api/intel/1/comment
  def add_comment
    @comment = IntelligenceCaseComment.new(intelligence_case_comment_params)

    # security check against the intel case
    @intelligence_case = IntelligenceCase.find_by_id(params[:id])
    if @intelligence_case.nil? || !current_user.db_user.classification_check(@intelligence_case.classification_level)
      render status: 404, json: { message: 'Intel case not found! Cannot add comment!' }
      return
    end

    # add case
    @comment.intelligence_case_id = params[:id]
    # add creator
    @comment.created_by_id = current_user.id

    # save it
    if @comment.save
      render status: :created, json: @comment.as_json(include: { created_by: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] } })
    else
      render json: @comment.errors.full_messages.to_sentence, status: :unprocessable_entity
    end
  end

  # api/intel/1/comment/2
  def delete_comment
    @intelligence_case_comment = IntelligenceCaseComment.find_by_id(params[:comment_id])

    # nil check
    if @intelligence_case_comment.nil?
      render status: 404, json: { message: 'Case comment not found!' }
    end

    # security check against the intel case
    if @intelligence_case_comment.intelligence_case.nil? || !current_user.db_user.classification_check(@intelligence_case_comment.intelligence_case.classification_level)
      render status: 404, json: { message: 'Intel case not found! Cannot add comment!' }
      return
    end

    # kill it
    if @intelligence_case.destroy
      render json: { message: 'Case comment removed!' }
    else
      render status: :unprocessable_entity, json: { message: 'Case comment could not be removed!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_intelligence_case
      puts params[:id]
      if params[:id] && params[:id].match(/^(?!.*--)[A-Za-z0-9-]*$/) # _- removed these for now
        clause = "id::text LIKE ? AND archived = false", "#{params[:id]}%"
        @intelligence_case = IntelligenceCase.where(clause).first
      end
    end

    def set_intelligence_case_comment
      @intelligence_case_comment = IntelligenceCaseComment.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def intelligence_case_params
      params.require(:intelligence_case).permit(:rsi_handle, :case_summary, :threat_level_id, :show_in_safe)
    end

    def intelligence_case_update_params
      params.require(:intelligence_case).permit(:case_summary, :threat_level_id, :show_in_safe, :classification_level_id, :tags)
    end

    def intelligence_case_comment_params
      params.require(:intelligence_case_comment).permit(:comment)
    end
end
