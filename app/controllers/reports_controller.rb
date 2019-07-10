class ReportsController < ApplicationController
  before_action :require_user
  before_action :require_member

  # need a report admin role?
  #  GET api/report
  def list
    @reports_fetch = Report.all
    @reports = []

    @reports_fetch.each do |report|
      @reports << report if current_user.id == report.submitter_id
    end

    render status: 200, json: @reports.as_json(methods: [:url_title_string, :report_time_ms], include: { report_status_type: {}, report_type: {}, specified_submit_to_role: {} })
  end

  # GET api/report/my
  def list_my
    @reports_fetch = Report.all
    @my_reports = []

    @reports_fetch.each do |report|
      @my_reports << report if current_user.isinrole(report.specified_submit_to_role_id) && report.submitted == true
    end

    render status: 200, json: @my_reports.as_json(methods: [:url_title_string, :report_time_ms], include: { submitter: { methods: [:main_character] }, report_status_type: {}, report_type: {}, specified_submit_to_role: {} })
  end

  #  GET /report/types
  def fetch_types
    render status: 200, json: ReportType.all
  end

  #  POST api/report/
  def create
    @report = Report.new(report_params)
    @report.submitter_id = current_user.id
    @report.report_status_type_id = 1
    if @report.save
      render status: 200, json: @report
    else
    end
  end

  #  PATCH api/report/
  def update
    @report = Report.find_by_id(params[:report][:id].to_i)
    if @report != nil
      if @report.submitter_id == current_user.id
        if @report.submitted == false
          if @report.update_attributes(report_update_params)
            render status: 200, json: @report
          else
            render status: 500, json: { message: "Report could not be updated." }
          end
        else
          render status: 403, json: { message: "Report has already been submitted it cannot be deleted." }
        end
      else
        render status: 403, json: { message: "This is not your report so you cannot submit it." }
      end
    else
      render status: 404, json: { message: "Report not found." }
    end
  end

  #  DELETE api/report/:report_id
  def delete
    @report = Report.find_by_id(params[:report_id].to_i)
    if @report != nil
      if @report.submitter_id == current_user.id
        if @report.submitted == false
          if @report.destroy
            render status: 200, json: { message: "Report deleted." }
          else
            render status: 500, json: { message: "Report could not be deleted." }
          end
        else
          render status: 403, json: { message: "Report has already been submitted it cannot be deleted." }
        end
      else
        render status: 403, json: { message: "This is not your report so you cannot delete it." }
      end
    else
      render status: 404, json: { message: "Report not found." }
    end
  end

  #  POST api/report/submit
  #  Body should contain :report_id
  def submit_for_approval
    @report = Report.find_by_id(params[:report_id].to_i)
    if @report != nil
      if @report.submitter_id == current_user.id
        if @report.submitted == false || @report.submitted == nil
          #Create the new approval request
          approvalRequest = ReportApprovalRequest.new
          # put the approval instance in the request
          approvalRequest.approval_id = new_approval(21, 0, @report.specified_submit_to_role_id) # report approval

          # lastly add the request to the current_user
          approvalRequest.user_id = current_user.id
          approvalRequest.report = @report
          @report.report_approval_request = approvalRequest

          @report.report_status_type_id = 2
          @report.submitted = true

          if @report.save
            render status: 200, json: { message: "Report submitted for approval." }
          else
            render status: 500, json: { message: "Something went wrong and the report could not be submitted for approval." }
          end
        else
          render status: 403, json: { message: "This report has already been submitted and cannot be submitted again" }
        end
      else
        render status: 403, json: { message: "This is not your report so you cannot submit it." }
      end
    else
      render status: 404, json: { message: "Report not found."}
    end
  end

  private
  def report_params
    params.require(:report).permit(:title, :description, :report_type_id, :specified_submit_to_role_id)
  end

  def report_update_params
    params.require(:report).permit(:id, :title, :description, :report_type_id, :specified_submit_to_role_id)
  end
end
