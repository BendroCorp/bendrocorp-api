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
    @reports = Report.where(archived: false) if current_user.is_in_role(49)
    @reports ||= Report.where('created_by_id = ? OR report_for_id = ?', current_user.id, current_user.id)
    render json: @reports.as_json(include: { handler: {}, template: {}, created_by: { only: [], methods: [:main_character] }, fields: { include: { field_value: {} } } } )
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

      # save the new report
      if @report.save
        # add fields
        @report.template.fields.each do |template_field|
          @report.fields << ReportField.new(report_id: @report.id, name: template_field.name, description: template_field.description, validator: template_field.validator, field_presentation_type_id: template_field.field_presentation_type_id, field_id: template_field.field_id, required: template_field.required, ordinal: template_field.ordinal)
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
      if @report.draft == true
        if params[:report][:draft] == false
          # approval_id = data[:approval_id]

          # create the new approval request
          approval_request = ReportApprovalRequest.new
          # put the approval instance in the request
          approval_request.approval_id = new_approval(21, @report.report_for_id) # report approval

          # lastly add the request to the current_user
          approval_request.user_id = current_user.id
          approval_request.report = @report

          # save back the approval request
          approval_request.save

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
      render status: 404, json: { message: 'You are not authorized to edit this report!' }
    end
  end

  # DELETE /reports/1
  def destroy
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
