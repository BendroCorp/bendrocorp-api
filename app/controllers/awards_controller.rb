class AwardsController < ApplicationController
  before_action :set_award, only: [:edit, :update, :destroy]
  before_action :require_user
  before_action :require_member
  before_action only: [:create, :edit, :update, :destroy] do |a|
    a.require_one_role([18,19])
  end

  # GET api/award
  def list
    @awards = Award.all
  end

  # POST api/award
  def create
    @award = Award.new(award_params)
    #eventually we will have the create request here
    if @award.save
      render status: :created, json: @award
    else
      render json: @award.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT api/award/:award_id
  def update
    if @award.update(award_params)
      render status: 200, json: @award
    else
      render json: @award.errors, status: :unprocessable_entity
    end
  end

  # DELETE api/award/:award_id
  def archive
    @award.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_award
      @award = Award.find(params[:id])
      if @award == nil
        render status: 404, json: { message: "Award not found. It may have been removed or deleted." }
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def award_params
      params.require(:award).permit(:name, :description, :points, :image, :outofband_awards_allowed, :multiple_awards_allowed)
      #params.fetch(:award, {})
    end
end
