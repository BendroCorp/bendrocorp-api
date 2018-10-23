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

    render status: 200, json: @offenders.as_json(include: { offender_reports: { include: { created_by: { } }, methods: [:occured_when_ms, :full_location] } })
  end

  # GET api/offender-report/types
  def list_types
    render status: 200, json: OffenderReportViolenceRating.all.as_json
  end

  # GET api/offender-report/mine
  def list_mine
    render status: 200, json: OffenderReport.where(:created_by => current_user).order('occured_when desc').as_json(include: { system: { include: { planets: { include: { moons: { } } } } }, planet: { include: { moons: { } } }, moon: {}, ship: {}, violence_rating: {}, offender: { } }, methods: [:full_location, :occured_when_ms])
  end

  # GET api/offender-report/admin
  def list_admin
    render status: 200, json: OffenderReport.all.order('occured_when desc').as_json(include: { created_by:{}, system: { include: { planets: { include: { moons: { } } } } }, planet: { include: { moons: { } } }, moon: {}, ship: {}, violence_rating: {}, offender: { } }, methods: [:full_location, :occured_when_ms])
  end

  # GET api/offender-report/:report_id
  def fetch

  end

  # POST api/offender-report
  # Body should contain offender_report object
  def create
    @offender_report = OffenderReport.new(offender_report_params)

    offender_check = OffenderReportOffender.find_by offender_name: params[:offender_report][:offender_attributes][:offender_name].to_s.downcase

    # If we find the offender with the same name use that
    if offender_check != nil
      @offender_report.offender = offender_check
    end

    @offender_report.occured_when = Time.at(params[:offender_report][:occured_when_ms].to_f / 1000)
    @offender_report.submitted_for_approval = false
    @offender_report.created_by = current_user

    # lastly save the item to the db
    if @offender_report.save
      render status: 200, json: @offender_report.as_json(include: { created_by:{}, system: { include: { planets: { include: { moons: { } } } } }, planet: { include: { moons: { } } }, moon: {}, ship: {}, violence_rating: {}, offender: { } }, methods: [:full_location, :occured_when_ms])
    else
      render status: 500, json: { message: 'Offender report not created.' }
    end
  end

  # PATCH api/offender-report
  # Body should contain offender_report object
  def update
    @offender_report = OffenderReport.find_by_id(params[:offender_report][:id].to_i)
    if @offender_report != nil && @offender_report.submitted_for_approval == false

      @offender_report.occured_when = Time.at(params[:offender_report][:occured_when_ms].to_f / 1000)

      if @offender_report.update_attributes(offender_report_update_params)
        render status: 200, json: { message:'Offender report updated.', data: @offender_report }
      else
        render status: 500, json: { message:'An error occured and the offender report could not be updated.', data: @offender_report }
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
        render status: 200, json: @offender_report.as_json(include: { created_by:{}, system: { include: { planets: { include: { moons: { } } } } }, planet: { include: { moons: { } } }, moon: {}, ship: {}, violence_rating: {}, offender: { } }, methods: [:full_location, :occured_when_ms])
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
        approvalRequest.user = current_user
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

  def add_bounty
    # TODO:
  end

  def update_bounty
    # TODO:
  end

  private
  def offender_report_params
    params.require(:offender_report).permit(:description, :violence_rating_id, :ship_id, :system_id, :planet_id, :moon_id, offender_attributes:[ :id, :offender_name, :offender_handle])
  end

  private
  def offender_report_update_params
    params.require(:offender_report).permit(:description, :violence_rating_id, :ship_id, :system_id, :planet_id, :moon_id)
  end
end
