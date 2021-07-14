class ProfileGroupsController < ApplicationController
  before_action :set_profile_group, only: [:show, :update, :destroy]

  # GET /profile_groups
  def index
    @profile_groups = ProfileGroup.all

    render json: @profile_groups
  end

  # GET /profile_groups/1
  def show
    render json: @profile_group
  end

  # POST /profile_groups
  def create
    @profile_group = ProfileGroup.new(profile_group_params)

    if @profile_group.save
      render json: @profile_group, status: :created, location: @profile_group
    else
      render json: @profile_group.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profile_groups/1
  def update
    if @profile_group.update(profile_group_params)
      render json: @profile_group
    else
      render json: @profile_group.errors, status: :unprocessable_entity
    end
  end

  # DELETE /profile_groups/1
  def destroy
    @profile_group.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_group
      @profile_group = ProfileGroup.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_group_params
      params.require(:profile_group).permit(:division_id, :parent_id, :title, :description, :ordinal)
    end
end
