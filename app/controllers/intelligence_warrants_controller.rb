class IntelligenceWarrantsController < ApplicationController
  before_action :set_intelligence_warrant, only: [:show, :update, :destroy]

  # GET /intelligence_warrants
  def index
    @intelligence_warrants = IntelligenceWarrant.all

    render json: @intelligence_warrants
  end

  # GET /intelligence_warrants/1
  def show
    render json: @intelligence_warrant
  end

  # POST /intelligence_warrants
  def create
    @intelligence_warrant = IntelligenceWarrant.new(intelligence_warrant_params)

    if @intelligence_warrant.save
      render json: @intelligence_warrant, status: :created, location: @intelligence_warrant
    else
      render json: @intelligence_warrant.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /intelligence_warrants/1
  def update
    if @intelligence_warrant.update(intelligence_warrant_params)
      render json: @intelligence_warrant
    else
      render json: @intelligence_warrant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /intelligence_warrants/1
  def destroy
    @intelligence_warrant.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_intelligence_warrant
      @intelligence_warrant = IntelligenceWarrant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def intelligence_warrant_params
      params.require(:intelligence_warrant).permit(:intelligence_case_id, :warrant_status_id, :closed, :boolean, :archived)
    end
end
