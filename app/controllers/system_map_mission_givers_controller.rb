class SystemMapMissionGiversController < ApplicationController
  before_action :set_system_map_mission_giver, only: [:show, :update, :archive]
  before_action :require_user
  before_action :require_member

  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23]) # editor
  end

  # all others methods should only be available to admins
  before_action only: [:archive] do |a|
    a.require_one_role([23]) # admin
  end

  # GET /system_map_mission_givers
  def index
    @system_map_mission_givers = SystemMapMissionGiver.where(archived: false)

    render json: @system_map_mission_givers.to_json(include: { faction_affiliation: {}, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } } }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
  end

  # GET /system_map_mission_givers/:uuid
  def show
    if @system_map_mission_giver
      render json: @system_map_mission_giver.to_json(include: { faction_affiliation: {}, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } } }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
    else
      render status: 404, json: { message: 'Mission giver not found!'}
    end
  end

  # POST /system_map_mission_givers
  def create
    @system_map_mission_giver = SystemMapMissionGiver.new(system_map_mission_giver_params)

    @system_map_mission_giver.discovered_by_id = current_user.id

    if params[:mission_giver][:new_primary_image] != nil
      if @system_map_mission_giver.primary_image != nil
        @system_map_mission_giver.primary_image.image = params[:mission_giver][:new_primary_image][:base64]
        @system_map_mission_giver.primary_image.image_file_name = params[:mission_giver][:new_primary_image][:name]
      else
        @system_map_mission_giver.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:mission_giver][:new_primary_image][:base64], image_file_name: params[:mission_giver][:new_primary_image][:name], title: @system_map_mission_giver.title, description: @system_map_mission_giver.title)
      end
    end

    if @system_map_mission_giver.save
      render json: @system_map_mission_giver.to_json(include: { faction_affiliation: {}, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } } }, methods: [:kind, :primary_image_url, :parent, :title_with_kind]), status: :created
    else
      render json: { message: @system_map_mission_giver.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_map_mission_givers/1
  def update
    if @system_map_mission_giver

      if params[:mission_giver][:new_primary_image] != nil
        if @system_map_mission_giver.primary_image != nil
          @system_map_mission_giver.primary_image.image = params[:mission_giver][:new_primary_image][:base64]
          @system_map_mission_giver.primary_image.image_file_name = params[:mission_giver][:new_primary_image][:name]
        else
          @system_map_mission_giver.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:mission_giver][:new_primary_image][:base64], image_file_name: params[:mission_giver][:new_primary_image][:name], title: @system_map_mission_giver.title, description: @system_map_mission_giver.title)
        end
      end

      if @system_map_mission_giver.update(system_map_mission_giver_params)
        render json: @system_map_mission_giver.to_json(include: { faction_affiliation: {}, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } } }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
      else
        render json: { message: @system_map_mission_giver.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Mission giver not found!' }
    end
  end

  # DELETE /system_map_mission_givers/1
  def archive
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
      params.require(:mission_giver).permit(:title, :description, :tags, :faction_affiliation_id, :on_system_object_id, :on_settlement_id, :on_location_id)
    end
end
