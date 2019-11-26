class ReportFieldValuesController < ApplicationController
  before_action :set_report_field_value, only: [:update]
  before_action :require_user
  before_action :require_member

  # PATCH/PUT /report_field_values/1
  def update
    if @report_field_value.update(report_field_value_params)
      render json: @report_field_value
    else
      render json: { message: @report_field_value.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report_field_value
      @report_field_value = ReportFieldValue.find(params[:field_value][:id])
    end

    # Only allow a trusted parameter "white list" through.
    def report_field_value_params
      params.require(:field_value).permit(:value)
    end
end
