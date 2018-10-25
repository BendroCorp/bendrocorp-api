class JobBoardController < ApplicationController
  before_action :require_user
  before_action :require_member

  before_action except: [:index, :fetch, :accept_mission, :abandon_mission, :complete_mission] do |a|
    a.require_one_role([28]) #job board admin
  end

  # GET api/job-board/
  # params[:mission_id]
  def list
    @missions = JobBoardMission.where('posting_approved = ? AND archived = ?', true, false).order('created_at DESC')
    render status: 200, json: @missions.order('created_at desc').as_json(methods: [:on_mission, :url_title_string, :created_time_ms], include: { completion_request: { include: { flight_log: { methods: [:log_time_ms, :full_location, :log_title], include: { image_uploads: { methods: [:image_url_large, :image_url_small, :image_url_original] }, owned_ship: { include: { character: { methods: :full_name}, ship: {}}, methods: :full_ship_title }, system: { include: { planets: { include: { moons: {}} } }}, planet: {}} } } }, mission_status:{}, created_by: { :only => [:username], methods: [:main_character] }, updated_by: { :only => [:username] }, completion_criteria: { } })
    # , not_approved_missions: @not_approved_missions.as_json(methods: [:on_mission], include: { completion_request: { methods: [:log_time_ms, :full_location, :log_title], include: { image_uploads: { methods: [:image_url_large, :image_url_small, :image_url_original] }, owned_ship: { include: { character: { methods: :full_name}, ship: {}}, methods: :full_ship_title }, system: { include: { planets: { include: { moons: {}} } }}, planet: {}} }, mission_status:{}, created_by: { :only => [:username], methods: [:main_character] }, updated_by: { :only => [:username] }, completion_criteria: {} })
  end

  # GET api/job-board/types
  def list_types
    render status: 200, json: JobBoardMissionCompletionCriterium.all
  end

  # POST api/job-board/
  # Body should contain job_board_mission object
  def create
    @mission = JobBoardMission.new(job_board_mission_params)
    @mission.created_by = current_user
    @mission.updated_by = current_user
    @mission.mission_status_id = 1 # open
    if @mission.save
      render status: 201, json: @missions.as_json(methods: [:on_mission, :url_title_string, :created_time_ms], include: { completion_request: { include: { flight_log: { methods: [:log_time_ms, :full_location, :log_title], include: { image_uploads: { methods: [:image_url_large, :image_url_small, :image_url_original] }, owned_ship: { include: { character: { methods: :full_name}, ship: {}}, methods: :full_ship_title }, system: { include: { planets: { include: { moons: {}} } }}, planet: {}} } } }, mission_status:{}, created_by: { :only => [:username], methods: [:main_character] }, updated_by: { :only => [:username] }, completion_criteria: { } })
    else
      render status: 500, json: { message: "Error Occured: Job board mission could not be created." }
    end
  end

  # PATCH api/job-board/
  # Body should contain job_board_mission object
  def update
    @mission = JobBoardMission.find_by_id(params[:job_board_mission][:id].to_i)
    if @mission != nil
      # /expires_when_me
      # :title, :description, :completion_criteria_id, :expires_when, :max_acceptors, :op_value, :system_id, :planet_id, :moon_id, :system_object_id, :location_id
      @mission.updated_by = current_user

      @mission.title = params[:job_board_mission][:title]
      @mission.description = params[:job_board_mission][:description]
      @mission.completion_criteria_id = params[:job_board_mission][:completion_criteria_id]
      # @mission.expires_when = Time.at(params[:job_board_mission][:expires_when_ms] / 1000.0) # NOTE: have to manually update to deal with this
      # # TODO: Deal with expirations
      @mission.max_acceptors = params[:job_board_mission][:max_acceptors]
      @mission.op_value = params[:job_board_mission][:op_value]
      @mission.system_id = params[:job_board_mission][:system_id]
      @mission.planet_id = params[:job_board_mission][:planet_id]
      @mission.moon_id = params[:job_board_mission][:moon_id]
      @mission.system_object_id = params[:job_board_mission][:system_object_id]
      @mission.location_id = params[:job_board_mission][:location_id]

      if @mission.save
        render status: 200, json: @mission.as_json(methods: [:on_mission, :url_title_string, :created_time_ms], include: { completion_request: { include: { flight_log: { methods: [:log_time_ms, :full_location, :log_title], include: { image_uploads: { methods: [:image_url_large, :image_url_small, :image_url_original] }, owned_ship: { include: { character: { methods: :full_name}, ship: {}}, methods: :full_ship_title }, system: { include: { planets: { include: { moons: {}} } }}, planet: {}} } } }, mission_status:{}, created_by: { :only => [:username], methods: [:main_character] }, updated_by: { :only => [:username] }, completion_criteria: { } })
      else
        render status: 500, json: { message: "Error Occured: Job board mission could not be updated." }
      end
    else
      render status: 404, json: { message: "Job board mission not found." }
    end
  end

  # DELETE api/job-board/:mission_id/
  # Body should include job_board_mission_id
  def delete
    @mission = JobBoardMission.find_by_id(params[:job_board_mission_id].to_i)
    if @mission != nil
      @mission.archived = true
      @mission.acceptors.delete_all
      if @mission.save
        render status: 200, json: { message: "Job board mission archived." }
      else
        render status: 500, json: { message: "Error Occured: Job board mission could not be archived." }
      end
    else
      render status: 404, json: { message: "Job board mission not found." }
    end
  end

  # POST api/job-board/accept
  # Body should contain job_board_mission_id
  def accept_mission
    @mission = JobBoardMission.find_by_id(params[:job_board_mission_id].to_i)
    if @mission != nil
      if @mission.mission_status_id == 1
        if @mission.acceptors.count < @mission.max_acceptors
          if @mission.acceptors.where('character_id = ?', current_user.main_character.id).count == 0
            @mission.acceptors << JobBoardMissionAcceptor.new(character: current_user.main_character)

            # if the mission is full start the time
            if @mission.acceptors.count >= @mission.max_acceptors
              @mission.accepted_when = Time.now
              @mission.acceptence_expires_when = Time.now + 72.hours
            end
           if @mission.save
             if @mission.acceptors.count == @mission.max_acceptors
               # TODO: Email all mission acceptors that the clock is running
             end

             # email the mission creator if not system
             render status: 200, json: @mission.as_json(methods: [:on_mission, :url_title_string, :created_time_ms], include: { completion_request: { include: { flight_log: { methods: [:log_time_ms, :full_location, :log_title], include: { image_uploads: { methods: [:image_url_large, :image_url_small, :image_url_original] }, owned_ship: { include: { character: { methods: :full_name}, ship: {}}, methods: :full_ship_title }, system: { include: { planets: { include: { moons: {}} } }}, planet: {}} } } }, mission_status:{}, created_by: { :only => [:username], methods: [:main_character] }, updated_by: { :only => [:username] }, completion_criteria: { } })
           else
             render status: 500, json: { message: "Error Occured: Job board mission could not be updated." }
           end
          else
            render status: 403, json: { message: "You have already accepted this mission." }
          end
        else
          render status: 403, json: { message: "This mission cannot be accepted by anyone else. #{@mission.acceptors.count} < #{@mission.max_acceptors}" }
        end
      else
        render status: 403, json: { message: "Mission is closed."}
      end
    else
      render status: 404, json: { message: "Job board mission not found." }
    end
  end

  # POST api/job-board/abandon
  # Body should contain :job_board_mission_id
  def abandon_mission #mission_completed
    @mission = JobBoardMission.find_by_id(params[:job_board_mission_id].to_i)
    if @mission != nil
      if @mission.mission_status_id == 1
        @yaya = @mission.acceptors.where('character_id = ?', current_user.main_character.id).first
        if @yaya != nil
          if @yaya.destroy
            @mission2 = JobBoardMission.find_by_id(params[:job_board_mission_id].to_i)
            render status: 200, json: @mission2.as_json(methods: [:on_mission, :url_title_string, :created_time_ms], include: { completion_request: { include: { flight_log: { methods: [:log_time_ms, :full_location, :log_title], include: { image_uploads: { methods: [:image_url_large, :image_url_small, :image_url_original] }, owned_ship: { include: { character: { methods: :full_name}, ship: {}}, methods: :full_ship_title }, system: { include: { planets: { include: { moons: {}} } }}, planet: {}} } } }, mission_status:{}, created_by: { :only => [:username], methods: [:main_character] }, updated_by: { :only => [:username] }, completion_criteria: { } })
          else
            render status: 500, json: { message: "Error Occured: Job board mission could not be abandoned." }
          end
        else
          render status: 404, json: { message: "An acceptence from you for this mission could not found." }
        end
      else
        render status: 403, json: { message: "Mission is closed. Status changes are no longer allowed." }
      end
    else
      render status: 404, json: { message: "Job board mission not found." }
    end
  end

  # POST api/job-board/complete
  # params[:completion_request][:mission_id|:completion_message|:flight_log_id]
  # May not ever use :child_approval
  def complete_mission
    #Approval approved
    @mission = JobBoardMission.find_by_id(params[:completion_request][:mission_id].to_i)
    if @mission != nil
      if @mission.mission_status_id == 1
        # check approval status
        if params[:completion_request][:child_approval] != nil
          # check to see if the child approval is approved
          child_approval = Approval.find_by_id(params[:completion_request][:child_approval].to_i)
          if child_approval.approved == true
            approvalRequest = JobBoardMissionCompletionRequest.new
            approvalRequest.approval_id = new_approval(18)
            approvalRequest.user = current_user

            approvalRequest.flight_log_id = params[:completion_request][:flight_log_id].to_i
            approvalRequest.completion_message = params[:completion_request][:completion_message]
            # approvalRequest.child_approval = child_approval # This is not in use right now
            approvalRequest.job_board_mission = @mission.id
            @mission.completion_request = approvalRequest
            @mission.mission_status_id = 2

            if @mission.save
              render status: 200, json: @mission.as_json(methods: [:on_mission, :url_title_string, :created_time_ms], include: { completion_request: { include: { flight_log: { methods: [:log_time_ms, :full_location, :log_title], include: { image_uploads: { methods: [:image_url_large, :image_url_small, :image_url_original] }, owned_ship: { include: { character: { methods: :full_name}, ship: {}}, methods: :full_ship_title }, system: { include: { planets: { include: { moons: {}} } }}, planet: {}} } } }, mission_status:{}, created_by: { :only => [:username], methods: [:main_character] }, updated_by: { :only => [:username] }, completion_criteria: { } })
            else
              render status: 500, json: { message: "Error Occured: Mission submitted for complete successfully." }
            end
          else
            render status: 403, json: { message: "Child approval is not approved. You cannot submit a completion request until it is approved." }
          end
        else # if child request param is nil
          if !@mission.completion_criteria.child_approval_required #if its not required
            approvalRequest = JobBoardMissionCompletionRequest.new
            approvalRequest.approval_id = new_approval(18)
            approvalRequest.user = current_user

            approvalRequest.flight_log_id = params[:completion_request][:flight_log_id].to_i
            approvalRequest.completion_message = params[:completion_request][:completion_message]
            approvalRequest.job_board_mission_id = @mission.id
            @mission.completion_request = approvalRequest
            @mission.mission_status_id = 2

            # save back
            if @mission.save
              render status: 200, json: @mission.as_json(methods: [:on_mission, :url_title_string, :created_time_ms], include: { completion_request: { include: { flight_log: { methods: [:log_time_ms, :full_location, :log_title], include: { image_uploads: { methods: [:image_url_large, :image_url_small, :image_url_original] }, owned_ship: { include: { character: { methods: :full_name}, ship: {}}, methods: :full_ship_title }, system: { include: { planets: { include: { moons: {}} } }}, planet: {}} } } }, mission_status:{}, created_by: { :only => [:username], methods: [:main_character] }, updated_by: { :only => [:username] }, completion_criteria: { } })
            else
              # Dispose of bad approval if an error occurs
              cancel_approval(approvalRequest.approval_id)

              render status: 500, json: { message: "Error Occured: Mission could not be submitted for completion because: #{@mission.errors.full_messages.to_sentence}" }
            end
          else
            render status: 403, json: { message: "A child approval is required to complete this request." }
          end
        end
      else
        render status: 403, json: { message: "Mission is already closed. Completion is in progress or cannot be made." }
      end
    else
      render status: 404, json: { message: "Job board mission not found." }
    end
  end

  private
  def job_board_mission_params
    params.require(:job_board_mission).permit(:title, :description, :completion_criteria_id, :starts_when, :expires_when, :max_acceptors, :op_value, :system_id, :planet_id, :moon_id, :system_object_id, :location_id)
  end

  def job_board_mission_update_params
    params.require(:job_board_mission).permit(:id, :title, :description, :completion_criteria_id, :starts_when, :expires_when, :max_acceptors, :op_value, :system_id, :planet_id, :moon_id, :system_object_id, :location_id)
  end
end
