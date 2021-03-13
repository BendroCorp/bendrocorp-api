class ProfileGroupsController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action except: [:index, :show] do |a|
    a.require_one_role([2])
  end

  before_action :set_profile_group, only: [:show, :update, :destroy]

  # GET /profile_groups
  def index
    @profile_groups = ProfileGroup.where(parent_id: nil)

    render json: @profile_groups.as_json(include: {}, methods: [:children_hash])
  end

  # GET /profile_groups/1
  def show
    render json: @profile_group
  end

  # POST /profile_groups
  def create
    @profile_group = ProfileGroup.new(profile_group_params)

    if @profile_group.save
      render json: @profile_group.as_json(include: {}, methods: [:children_hash]), status: :created
    else
      render json: { message: @profile_group.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profile_groups/1
  def update
    if @profile_group.update(profile_group_params)
      render json: @profile_group.as_json(include: {}, methods: [:children_hash])
    else
      render json: { message: @profile_group.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # DELETE /profile_groups/1
  def destroy
    @profile_group.archived = true
    if @profile_group.save
      render json: { message: 'Profile group archived!' }
    else
      
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_group
      @profile_group = ProfileGroup.find(params[:id])
      @profile_group ||= ProfileGroup.find(params[:profile_group][:id])
    end

    # Only allow a trusted parameter "white list" through.
    def profile_group_params
      params.require(:profile_group).permit(:title, :description, :parent_id, :ordinal, :archived)
    end
end
