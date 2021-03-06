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
    reports = Report.where(archived: false).order(created_at: :desc) if current_user.is_in_role(49)
    reports ||= Report.where('user_id = ? AND archived = false', current_user.id).order(created_at: :desc)

    # reports which are for me
    reports_for_me = Report.where(archived: false).map do |report|
      report if report.report_for &&
      ((!report.report_for.for_user_id.nil? && report.report_for.for_user_id == current_user.id) || (!report.report_for.for_role_id.nil? && current_user.is_in_role(report.report_for.for_role_id)))
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

    render json: reports_final.as_json(include: { approval: {}, report_for: {}, handler: {}, template: {}, user: { only: [], methods: [:main_character] }, fields: { include: { field: { methods: [:descriptors] }, field_value: { methods: [:descriptor_value] } } } } )
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

  # GET /reports/:id
  def show
    # check to make sure the report exists
    if @report
      if @report.user_id == current_user.id || current_user.is_in_role(49) || (report.report_for && (report.report_for.for_user_id == current_user.id || current_user.is_in_role(report.report_for.for_role_id)))
        render json: @report.as_json(include: { approval: {}, report_for: {}, handler: {}, template: {}, user: { only: [], methods: [:main_character] }, fields: { include: { field: { methods: [:descriptors] }, field_value: { methods: [:descriptor_value] } } } } )
        return
      end
    end

    render status: :not_found, json: { message: 'Report not found or you do not have the rights to view it!' }
  end

  # POST /reports
  def create
    # take the params
    @report = Report.new(report_create_params)

    # valid template?
    if @report.template && (!@report.template.role || current_user.is_in_role(48) || current_user.is_in_role(@report.template.role_id))

      # Makes sure that all of the updates/changes happen
      Report.transaction do
        # fill in values from template
        @report.template_name = @report.template.name
        @report.template_description = @report.template.description

        # set created by
        @report.user_id = current_user.id

        # just grab the first available handler for a draft
        @report.handler_id = @report.template.handler_id

        # get default routing - if present
        @report.report_for_id = @report.template.report_for_id if !@report.template.report_for_id.nil? && @report.template.report_for_id != 0

        # save the new report
        if @report.save!
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
              hidden: template_field.hidden,
              report_handler_variable_id: template_field.report_handler_variable_id,
              # field_value: ReportFieldValue.new(report_id: @report.id)
            )
          end

          # save the field back after we build the field
          if @report.save!
            # create the value entries
            @report.fields.each do |field|
              ReportFieldValue.create(field_id: field.id) # , report_id: @report.id
            end

            render json: @report.as_json(include: { approval: {}, report_for: {}, handler: {}, template: {}, user: { only: [], methods: [:main_character] }, fields: { include: { field: { methods: [:descriptors] }, field_value: { methods: [:descriptor_value] } } } } ), status: :created
          else
            render json: { message: @report.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        else
          render json: { message: @report.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end # end of transaction
    else
      render status: 400, json: { message: 'Template invalid or missing' }
    end
  end

  # PATCH/PUT /reports/1
  def update
    if current_user.id == @report.user_id

      if @report.archived
        render status: 403, json: { message: 'This report is archived and cannot be updated!' }
        return
      end

      # transaction to make sure that all of these complex things actually happen
      Report.transaction do
        # make sure the report is a draft, otherwise block further editing
        if @report.draft == true
          if params[:report][:draft] == false
            # check to make sure any default values are assigned if applicable
            @report.fields.each do |field|
              if !field.default_value.nil? && (field.field_value.value.nil? || field.field_value.value == '')
                field.field_value.value = field.default_value
                field.save!
              end
            end

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
              approval = Approval.find_by_id(request_clazz.approval_id)
              approval.report_id = @report.id
              approval.save

              @report.approval_id = approval.id

            # or is this a generic report request
            else
              # put the approval instance in the request based on the routed user or group
              # for user
              @report.approval_id = new_approval(21, @report.report_for.for_user_id) unless @report.report_for.for_user_id.nil? 
              # for group
              @report.approval_id = new_approval(21, 0, @report.report_for.for_role_id) unless @report.report_for.for_role_id.nil?
            end

            # mark the report as not a draft
            @report.draft = false
          end # if the incoming params changes report to non-draft

          # attempt to update the report
          if @report.update(report_update_params)
            render json: @report.as_json(include: { approval: {}, report_for: {}, handler: {}, template: {}, user: { only: [], methods: [:main_character] }, fields: { include: { field: { methods: [:descriptors] }, field_value: { methods: [:descriptor_value] } } } } )
          else
            render json: { message: @report.errors.full_messages.to_sentence }, status: :unprocessable_entity
          end
        else
          render status: 403, json: { message: 'The report has already been submitted for approval and cannot be updated!' }
        end
      end # end of transaction block
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

    if (current_user.id == @report.user_id && @report.draft) || current_user.is_in_role(49)
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
