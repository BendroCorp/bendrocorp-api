class ReportTemplatesController < ApplicationController
  before_action :set_report_template, only: [:show, :update, :destroy]
  before_action :require_user
  before_action :require_member
  before_action except: [:index] do |a|
    a.require_one_role([48]) # report builder
  end

  # GET /report_templates
  def index
    @report_templates = ReportTemplate.where(archived: false)
    render json: @report_templates.as_json(include: { fields: { } })
  end

  # GET /report_templates/:uuid
  def show
    render json: @report_template.as_json(include: { fields: { } })
  end

  # POST /report_templates
  def create
    @report_template = ReportTemplate.new(report_template_params)

    # add basic user vars
    @report_template.created_by_id = current_user.id
    @report_template.updated_by_id = current_user.id

    # use the first handler available
    @report_template.handler_id = ReportHandler.all.first.id

    if @report_template.save
      render json: @report_template.as_json(include: { fields: { } })
    else
      render json: { message: @report_template.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /report_templates/
  def update
    @report_template.updated_by_id = current_user.id
    
    if @report_template.update(report_template_params)
      render json: @report_template.as_json(include: { fields: { } })
    else
      render json: { message: @report_template.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # DELETE /report_templates/:uuid
  def destroy
    if @report_template
      @report_template.updated_by_id = current_user.id
      @report_template.archived = true
      if @report_template.save
        render json: { message: 'Report template archived!' }
      else
        render json: { message: @report_template.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Report not found!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report_template
      @report_template = ReportTemplate.find(params[:report_template][:id]) if params[:report_template]
      @report_template ||= ReportTemplate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def report_template_params
      params.require(:report_template).permit(:name, :description, :draft, :handler_id)
    end
end
