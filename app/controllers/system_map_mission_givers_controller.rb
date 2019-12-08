class SystemMapMissionGiversController < ApplicationController
  before_action :set_system_map_mission_giver, only: [:show, :update, :destroy]
  before_action :require_user
  before_action :require_member

  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23]) # editor
   end
 
   # all others methods should only be available to admins
   before_action only: [:destory] do |a|
    a.require_one_role([23]) # admin
   end

  # GET /system_map_mission_givers
  def index
    @system_map_mission_givers = SystemMapMissionGiver.all

    render json: @system_map_mission_givers
  end

  # GET /system_map_mission_givers/:uuid
  def show
    if @system_map_mission_giver
      render json: @system_map_mission_giver
    else
      render status: 404, json: { message: 'Mission giver not found!'}
    end
  end

  # POST /system_map_mission_givers
  def create
    @system_map_mission_giver = SystemMapMissionGiver.new(system_map_mission_giver_params)

    if @system_map_mission_giver.save
      render json: @system_map_mission_giver, status: :created, location: @system_map_mission_giver
    else
      render json: @system_map_mission_giver.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_map_mission_givers/1
  def update
    if @system_map_mission_giver
      if @system_map_mission_giver.update(system_map_mission_giver_params)
        render json: @system_map_mission_giver
      else
        render json: @system_map_mission_giver.errors, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Mission giver not found!' }
    end
  end

  # DELETE /system_map_mission_givers/1
  def destroy
    if @system_map_mission_giver
      @system_map_mission_giver.archived = true
      if @system_map_mission_giver.save
      else
        render status: 500, json: { message: "Mission giver could not be archived because: #{@system_map_mission_giver.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Mission giver not found!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_map_mission_giver
      @system_map_mission_giver = SystemMapMissionGiver.find(params[:mission_giver][:id])
      @system_map_mission_giver ||= SystemMapMissionGiver.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_map_mission_giver_params
      params.require(:mission_giver).permit(:title, :description, :faction_affiliation_id, :on_moon_id, :on_planet_id, :on_system_object_id, :on_settlement_id, :on_location_id)
    end
end
