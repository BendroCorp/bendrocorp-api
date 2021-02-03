class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :update, :destroy]
  before_action :require_user
  before_action :require_member
  before_action only: [] do |a|
    # a.require_one_role([48]) # template builder
    # a.require_one_role([49]) # reports admin
  end

  # GET /reports
  def index
    # get reports that I have access to
    reports = Report.where(archived: false) if current_user.is_in_role(49)
    reports ||= Report.where('created_by_id = ? AND archived = false', current_user.id)

    # reports which are for me
    reports_for_me = Report.where(archived: false).map do |report|
      report if report.report_for && (report.report_for.for_user_id == current_user.id || current_user.is_in_role(report.report_for.for_role_id))
    end

    reports_final = []

    reports.each do |report|
      reports_final << report
    end

    reports_for_me.each do |report|
      reports_final << report if !report.nil?
    end

    # remove any empty elements
    reports_final.reject { |c| c.nil? }

    # uniq items only
    reports_final.uniq!

    render json: reports_final.as_json(include: { handler: {}, template: {}, created_by: { only: [], methods: [:main_character] }, fields: { include: { field_value: {} } } } )
  end

  # GET /reports/routes
  # The people who a report can be directed towards
  def fetch_routes
    render json: ReportRoute.where(archived: false)
  end

  # GET /reports/handlers
  def fetch_handlers
    render json: ReportHandler.where(archived: false).as_json(include: { variables: {} })
  end

  # POST /reports
  def create
    # take the params
    @report = Report.new(report_create_params)

    # valid template?
    if @report.template && (!@report.template.role || current_user.is_in_role(48) || current_user.is_in_role(@report.template.role_id))

      # fill in values from template
      @report.template_name = @report.template.name
      @report.template_description = @report.template.description

      # set created by
      @report.created_by_id = current_user.id

      # just grab the first available handler for a draft
      @report.handler_id = @report.template.handler_id

      # get default routing - if present
      @report.report_for_id = @report.template.report_for_id if !@report.template.report_for_id.nil? && @report.template.report_for_id != 0

      # save the new report
      if @report.save
        # add fields
        @report.template.fields.each do |template_field|
          @report.fields << ReportField.new(
            report_id: @report.id, 
            name: template_field.name,
            description: template_field.description,
            validator: template_field.validator,
            field_presentation_type_id: template_field.field_presentation_type_id,
            field_id: template_field.field_id,
            required: template_field.required,
            ordinal: template_field.ordinal,
            report_handler_variable_id: template_field.report_handler_variable_id
          )
        end

        # save the field back
        if @report.save
          render json: @report, status: :created
        else
          render json: { message: @report.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      else
        render json: { message: @report.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 400, json: { message: 'Template invalid or missing' }
    end
  end

  # PATCH/PUT /reports/1
  def update
    if current_user.id == @report.created_by_id

      if @report.archived
        render status: 403, json: { message: 'This report is archived and cannot be updated!' }
        return
      end

      # make sure the report is a draft, otherwise block further editing
      if @report.draft == true
        if params[:report][:draft] == false
          # make sure that the report has been routed or is handled by a class handler
          if @report.report_for.nil? && @report.handler.for_class.nil?
            render status: 400, json: { message: 'You must select a route for your report!' }
            return
          end

          # is this for a particular active record class
          if !@report.handler.for_class.nil?
            # get the class we are trying to handle, these classes are expected to be "Request" formatted object ActiveRecord tables 
            request_clazz = @report.handler.for_class.constantize.new

            @report.handler.variables.each do |variable|
              # get variable value from the assigned field
              field_variable_value = @report.fields.where(report_handler_variable_id: variable.id).first.field_value.value

              # filling the variable names
              request_clazz.send("#{variable.object_name}=", field_variable_value)
            end

            # create an approval object for that approval
            # NOTE/TODO: Do we deprecate the old way of doing this??
            request_clazz.approval_id = new_approval(@report.handler.approval_kind_id)
            request_clazz.user_id = current_user.id

            # attempt to save the request class
            # strong valdiation is required here on the model itself
            if !request_clazz.save
              cancel_approval(request_clazz.approval_id)
              render status: 500, json: { message: "Report could not be submitted because: #{request_clazz.errors.full_messages.to_sentence}" }
              return
            end

            # update the approval with the report_id
            approval = Approval.find_by_id(approval_request.approval_id)
            approval.report_id = @report.id
            approval.save

          # or is this a generic request
          else
            # create the default report approval request
            approval_request = ReportApprovalRequest.new

            # put the approval instance in the request based on the routed user or group
            # for user
            approval_request.approval_id = new_approval(21, @report.report_for.for_user_id) unless @report.report_for.for_user_id.nil? 
            # for group
            approval_request.approval_id = new_approval(21, 0, @report.report_for.for_role_id) unless @report.report_for.for_role_id.nil? 

            # lastly add the request to the current_user
            approval_request.user_id = current_user.id
            approval_request.report = @report

            # save back the approval request
            approval_request.save

            # update the approval with the report_id
            approval = Approval.find_by_id(approval_request.approval_id)
            approval.report_id = @report.id
            approval.save
          end

          # mark the report as not a draft
          @report.draft = false
        end
        if @report.update_attributes(report_update_params)
          render json: @report.as_json(include: { fields: { include: { field_value: {} } } } )
        else
          render json: { message: @report.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      else
        render status: 403, json: { message: 'The report has already been submitted for approval and cannot be updated!' }
      end
    else
      render status: 404, json: { message: 'The report does not exist or you are not authorized to edit it!' }
    end
  end

  # DELETE /reports/1
  def destroy
    if @report.nil?
      render status: 404, json: { message: 'Report does not exist!' }
      return
    end

    if @report.archived
      render status: 403, json: { message: 'This report has already been archived!' }
      return
    end

    if (current_user.id == @report.created_by_id && @report.draft) || current_user.is_in_role(49)
      @report.archived = true
      if @report.save
        render json: { message: 'Report archived!' }
      else
        render json: { message: @report.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:report][:id]) if params[:report]
      @report ||= Report.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def report_create_params
      params.require(:report).permit(:template_id)
    end

    def report_update_params
      params.require(:report).permit(:report_for_id, :draft)
    end
end
