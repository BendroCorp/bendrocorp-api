class SystemMapMoonsController < ApplicationController
  before_action :set_system_map_moon, only: [:show, :update, :archive]
  before_action :require_user
  before_action :require_member

  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23]) # editor
  end

  # all others methods should only be available to admins
  before_action only: [:archive] do |a|
    a.require_one_role([23]) # admin
  end

  # GET /system_map_moons
  def index
    @system_map_moons = SystemMapSystemPlanetaryBodyMoon.where(archived: false)

    render json: @system_map_moons.to_json(include: { system_map_images: {}, settlements: {}, locations: { include: { mission_givers: {} }}, system_objects: {}, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
  end

  # GET /system_map_moons/1
  def show
    if @system_map_moon
      render json: @system_map_moon.to_json(include: { system_map_images: {}, settlements: {}, locations: { include: { mission_givers: {} }}, system_objects: {}, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
    else
      render status: 404, json: { message: 'Moon not found!' }
    end
  end

  # POST /system_map_moons
  def create
    @system_map_moon = SystemMapSystemPlanetaryBodyMoon.new(system_map_moon_params)

    if params[:moon][:new_primary_image] != nil
      if @system_map_moon.primary_image != nil
        @system_map_moon.primary_image.image = params[:moon][:new_primary_image][:base64]
        @system_map_moon.primary_image.image_file_name = params[:moon][:new_primary_image][:name]
      else
        @system_map_moon.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:moon][:new_primary_image][:base64], image_file_name: params[:moon][:new_primary_image][:name], title: @system_map_moon.title, description: @system_map_moon.title)
      end
    end

    if @system_map_moon.save
      render json: @system_map_moon.to_json(include: { system_map_images: {}, settlements: {}, locations: { include: { mission_givers: {} }}, system_objects: {}, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind]), status: :created
    else
      render json: { message: @system_map_moon.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_map_moons/1
  def update
    if @system_map_moon

      if params[:moon][:new_primary_image] != nil
        if @system_map_moon.primary_image != nil
          @system_map_moon.primary_image.image = params[:moon][:new_primary_image][:base64]
          @system_map_moon.primary_image.image_file_name = params[:moon][:new_primary_image][:name]
        else
          @system_map_moon.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:moon][:new_primary_image][:base64], image_file_name: params[:moon][:new_primary_image][:name], title: @system_map_moon.title, description: @system_map_moon.title)
        end
      end

      if @system_map_moon.update(system_map_moon_params)
        render json: @system_map_moon.to_json(include: { system_map_images: {}, settlements: {}, locations: { include: { mission_givers: {} }}, system_objects: {}, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
      else
        render json: { message: @system_map_moon.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Moon not found!' }
    end
  end

  # DELETE /system_map_moons/1
  def archive
    if @system_map_moon
      @system_map_moon.archived = true
      if @system_map_moon.save
        render json: { message: 'Moon archived!' }
      else
        render json: { message: @system_map_moon.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Moon not found!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_map_moon
      @system_map_moon = SystemMapSystemPlanetaryBodyMoon.find(params[:moon][:id])
      @system_map_moon ||= SystemMapSystemPlanetaryBodyMoon.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_map_moon_params
      params.require(:moon).permit(:title, :description, :tags, :orbits_planet_id, :population_density, :economic_rating, :general_radiation, :atmospheric_height, :atmo_pressure, :tempature_max, :tempature_min, :minimum_criminality_rating, :jurisdiction_id, :faction_affiliation_id)
    end
end
