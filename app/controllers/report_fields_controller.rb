class ReportFieldsController < ApplicationController
  before_action :set_report_field, only: [:show, :update, :destroy]
  before_action :require_user
  before_action :require_member
  before_action except: [] do |a|
    a.require_one_role([48])
  end

  # GET /report_fields
  def index
    @report_fields = ReportTemplateField.all

    render json: @report_fields
  end

  # POST /report_fields
  def create
    @report_field = ReportTemplateField.new(report_create_field_params)
    @report_field.name = 'New field'
    @report_field.ordinal = ReportTemplateField.where(template_id: @report_field.template_id, archived: false).count + 1
    if @report_field.save
      render json: @report_field
    else
      render json: { message: @report_field.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /report_fields/1
  def update
    if @report_field.update(report_update_field_params)
      render json: @report_field
    else
      render json: { message: @report_field.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # DELETE /report_fields/1
  def destroy
    @report_field.archived = true
    if @report_field.save
      render json: { message: 'Field archived!' }
    else
      render json: { message: @report_field.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report_field
      @report_field = ReportTemplateField.find(params[:report_field][:id]) if params[:report_field]
      @report_field ||= ReportTemplateField.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def report_create_field_params
      params.require(:report_field).permit(:template_id, :name, :validator, :field_presentation_type_id, :field_id, :required, :ordinal, :report_handler_variable_id)
    end

    def report_update_field_params
      params.require(:report_field).permit(:name, :description, :validator, :field_presentation_type_id, :field_id, :required, :ordinal, :report_handler_variable_id)
    end
end
