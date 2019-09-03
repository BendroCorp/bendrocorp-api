require 'httparty'

class OffenderReportsController < ApplicationController
  before_action :require_user
  before_action :require_member

  before_action only: [:list_admin, :archive] do |a|
    a.require_one_role([16]) # offender report admin
  end

  # GET api/offender-report
  def list
    # TODO: Update this with the model to model method of doing this
    # TODO: May have to go back to the merge method
    @offenders_all = OffenderReportOffender.all

    # Create the outgoing list
    @offenders = []

    # Go through the grand list and filter our offenders without a valid offender reports
    @offenders_all.each do |offender|
      @offenders << offender if offender.offender_reports.count > 0
    end

    render status: 200, json: @offenders.as_json(include: { offender_rating: { }, offender_report_org: { include: { violence_rating: { }, known_offenders: { } } }, offender_reports: { include: { offender: {}, infractions: {}, force_level_applied: {}, created_by: { only: [:username], methods: [:main_character] } }, methods: [:occured_when_ms, :full_location] } })
  end

  # GET api/offender-report/offender/:offender_id
  def fetch_offender
    @offender = OffenderReportOffender.find_by_id(params[:offender_id])
    if @offender
      render status: 200, json: @offender.as_json(include: { offender_rating: { }, offender_report_org: { include: { violence_rating: { }, known_offenders: { } } }, offender_reports: { include: { offender: {}, infractions: {}, force_level_applied: {}, created_by: { only: [:username], methods: [:main_character] } }, methods: [:occured_when_ms, :full_location] } })
    else
      render status: 404, json: { message: "Offender not found!" }
    end
  end

  # GET api/offender-reports/verify/:rsi_handle
  def verify_rsi_handle
    page = HTTParty.get("https://robertsspaceindustries.com/citizens/#{params[:rsi_handle]}")
    render status: 200, json: page.code == 200
  end

  # GET api/offender-report/types
  def list_types
    render status: 200, json: OffenderReportViolenceRating.all.as_json
  end

  # GET api/offender-report/mine
  def list_mine
    render status: 200, json: OffenderReport.where(created_by_id: current_user.id).order('occured_when desc').as_json(include: { infractions: {}, force_level_applied: {}, system: { include: { planets: { include: { moons: { } } } } }, planet: { include: { moons: { } } }, moon: {}, ship: {}, violence_rating: {}, offender: { } }, methods: [:full_location, :occured_when_ms])
  end

  # GET api/offender-report/admin
  def list_admin
    render status: 200, json: OffenderReport.all.order('occured_when desc').as_json(include: { infractions: {}, force_level_applied: {}, created_by:{ only: [:username], methods: [:main_character] }, system: { include: { planets: { include: { moons: { } } } } }, planet: { include: { moons: { } } }, moon: {}, ship: {}, violence_rating: {}, offender: { } }, methods: [:full_location, :occured_when_ms])
  end

  # GET api/offender-report/:report_id
  def fetch
    @offender_report = OffenderReport.find_by_id(params[:report_id])
    # Exists & Security Check
    if @offender_report && (@offender_report.report_approved || (@offender_report.created_by_id == current_user.id || current_user.isinrole(16)))
      render status: 200, json: @offender_report.as_json(include: { offender: {}, infractions: {}, force_level_applied: {}, created_by: { only: [:username], methods: [:main_character] } }, methods: [:occured_when_ms, :full_location])
    else
      render status: 404, json: { message: "Offender report not found!" }
    end
  end

  # POST api/offender-report
  # Body should contain offender_report object
  def create
    @offender_report = OffenderReport.new(offender_report_params)

    offender_check = OffenderReportOffender.find_by offender_name: params[:offender_report][:offender_attributes][:offender_name].to_s.downcase

    # If we find the offender with the same name use that rather than creating a new one
    if offender_check != nil
      @offender_report.offender = offender_check
    end

    @offender_report.occured_when = Time.at(params[:offender_report][:occured_when_ms].to_f / 1000)
    @offender_report.submitted_for_approval = false
    @offender_report.created_by_id = current_user.id

    # Handle adding the intial infractions from params[:offender_report][:new_infractions]
    puts params[:offender_report][:new_infractions]
    params[:offender_report][:new_infractions].to_a.each do |infraction|
      found_infraction = OffenderReportInfraction.find_by_id(infraction[:id].to_i)
      @offender_report.infractions_committed << OffenderReportInfractionsCommitted.new(infraction: found_infraction) if found_infraction
    end

    puts "#{@offender_report.infractions_committed.inspect}"
    puts "Infractions: #{@offender_report.infractions_committed.count}"

    # lastly save the item to the db
    if @offender_report.save
      render status: 200, json: @offender_report.as_json(include: { infractions: {}, force_level_applied: {}, created_by:{}, system: { include: { planets: { include: { moons: { } } } } }, planet: { include: { moons: { } } }, moon: {}, ship: {}, violence_rating: {}, offender: { } }, methods: [:full_location, :occured_when_ms])
    else
      puts @offender_report.errors.inspect
      render status: 500, json: { message: "Offender report could not be created because: #{@offender_report.errors.full_messages.to_sentence}" }
    end
  end

  # PATCH api/offender-report
  # Body should contain offender_report object
  def update
    @offender_report = OffenderReport.find_by_id(params[:offender_report][:id].to_i)
    if @offender_report != nil && @offender_report.submitted_for_approval == false
      # security check
      if @offender_report.created_by_id == current_user.id || current_user.isinrole(16) # offender report admin
        @offender_report.occured_when = Time.at(params[:offender_report][:occured_when_ms].to_f / 1000)

        # Handle removing the infractions from params[:offender_report][:remove_infractions]
        params[:offender_report][:remove_infractions].each do |infraction|
          @offender_report.infractions_committed.where(infraction_id: infraction[:id].to_i).delete_all
        end

        # Handle adding the intial infractions from params[:offender_report][:new_infractions]
        params[:offender_report][:new_infractions].each do |infraction|
          found_infraction = OffenderReportInfraction.find_by_id(infraction[:id].to_i)
          @offender_report.infractions_committed << OffenderReportInfractionsCommitted.new(infraction: found_infraction) if found_infraction
        end

        # Save back
        if @offender_report.update_attributes(offender_report_update_params)
          render status: 200, json: @offender_report.as_json(include: { infractions: {}, force_level_applied: {}, created_by:{}, system: { include: { planets: { include: { moons: { } } } } }, planet: { include: { moons: { } } }, moon: {}, ship: {}, violence_rating: {}, offender: { } }, methods: [:full_location, :occured_when_ms])
        else
          render status: 500, json: { message:"The offender report could not be updated because: #{@offender_report.errors.full_messages.to_sentence}" }
        end

      else
        render status: 403, json: { message: "You do not have the rights to edit this offender report!" }
      end
    else
      render status: 404, json: { message: 'Either the requested report was not found or it is locked for approval.' }
    end
  end

  # DELETE api/offender-report/:report_id
  def archive
    @offender_report = OffenderReport.find_by_id(params[:offender_report][:id].to_i)
    if @offender_report
      @offender_report.archived = true
      if @offender_report.save
        render status: 200, json: @offender_report.as_json(include: { infractions: {}, force_level_applied: {}, created_by:{}, system: { include: { planets: { include: { moons: { } } } } }, planet: { include: { moons: { } } }, moon: {}, ship: {}, violence_rating: {}, offender: { } }, methods: [:full_location, :occured_when_ms])
      else
        render status: 500, json: { message: "Offender report could not be archived because: #{@offender_report.errors.full_messages.to_sentence}." }
      end
    else
      render status: 404, json: { message: 'Offender report not found!' }
    end
  end

  # POST api/offender-report/submit
  def submit
    # cancel_approval(approvalRequest.approval_id)
    @offender_report = OffenderReport.find_by_id(params[:offender_report][:id].to_i)
    if @offender_report != nil && @offender_report.submitted_for_approval == false

      begin
        approvalRequest = OffenderReportApprovalRequest.new

        # put the approval instance in the request
        approvalRequest.approval_id = new_approval(7) # offender report approval

        # lastly add the request to the current_user
        approvalRequest.user_id = current_user.id
        approvalRequest.offender_report = @offender_report
        approvalRequest.save #save the approvalRequest
        @offender_report.offender_report_approval_request = approvalRequest
        @offender_report.submitted_for_approval = true # change it to a submitted status
      rescue StandardError
        cancel_approval(approvalRequest.approval_id)
      end

      if @offender_report.save
        render status: 200, json: @offender_report.as_json(include: { created_by:{}, system: { include: { planets: { include: { moons: { } } } } }, planet: { include: { moons: { } } }, moon: {}, ship: {}, violence_rating: {}, offender: { } }, methods: [:full_location, :occured_when_ms])
      else
        cancel_approval(approvalRequest.approval_id) # if we fail then cancel the approval
        render status: 500, json: { message: "Offender report could not be submitted for approval because: #{@offender_report.errors.full_messages.to_sentence}." }
      end
    else
      render status: 404, json: { message: 'Offender report not found!' }
    end
  end

  # GET api/offender-report/infractions
  def list_infractions
    render status: 200, json: OffenderReportInfraction.all
  end

  # GET api/offender-report/force-levels
  def list_force_levels
    render status: 200, json: OffenderReportForceLevel.all
  end

  def add_bounty
    # TODO:
  end

  def update_bounty
    # TODO:
  end

  private
  def offender_report_params
    params.require(:offender_report).permit(:description, :violence_rating_id, :force_level_applied_id, :ship_id, :system_id, :planet_id, :moon_id, offender_attributes:[ :id, :offender_name, :offender_handle])
  end

  private
  def offender_report_update_params
    params.require(:offender_report).permit(:description, :violence_rating_id, :force_level_applied_id, :ship_id, :system_id, :planet_id, :moon_id)
  end
end
