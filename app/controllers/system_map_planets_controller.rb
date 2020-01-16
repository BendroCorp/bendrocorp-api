class SystemMapPlanetsController < ApplicationController
  before_action :set_system_map_planet, only: [:show, :update, :archive]
  before_action :require_user
  before_action :require_member

  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23]) # editor
  end

  # all others methods should only be available to admins
  before_action only: [:archive] do |a|
    a.require_one_role([23]) # admin
  end

  # GET /system_map_planets
  def index
    @system_map_planets = SystemMapSystemPlanetaryBody.where(archived: false)
    .to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } }, settlements: {}, locations: {}, moons: {}, system_objects: {}, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :primary_image_url_full, :parent, :title_with_kind])

    render json: @system_map_planets
  end

  # GET /system_map_planets/1
  def show
    if @system_map_planet
      render json: @system_map_planet.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } }, settlements: {}, locations: {}, moons: {}, system_objects: {}, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :primary_image_url_full, :parent, :title_with_kind])
    else
      render status: 404, json: { message: 'Planet not found!' }
    end
  end

  # POST /system_map_planets
  def create
    @system_map_planet = SystemMapSystemPlanetaryBody.new(system_map_planet_params)

    @system_map_planet.discovered_by_id = current_user.id

    if params[:planet][:new_primary_image] != nil
      if @system_map_planet.primary_image != nil
        @system_map_planet.primary_image.image = params[:planet][:new_primary_image][:base64]
        @system_map_planet.primary_image.image_file_name = params[:planet][:new_primary_image][:name]
      else
        @system_map_planet.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:planet][:new_primary_image][:base64], image_file_name: params[:planet][:new_primary_image][:name], title: @system_map_planet.title, description: @system_map_planet.title)
      end
    end

    if @system_map_planet.save
      render json: @system_map_planet.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } }, settlements: {}, locations: {}, moons: {}, system_objects: {}, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :primary_image_url_full, :parent, :title_with_kind]), status: :created
    else
      render json: { message: @system_map_planet.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_map_planets/1
  def update
    if @system_map_planet
      if params[:planet][:new_primary_image] != nil
        if @system_map_planet.primary_image != nil
          @system_map_planet.primary_image.image = params[:planet][:new_primary_image][:base64]
          @system_map_planet.primary_image.image_file_name = params[:planet][:new_primary_image][:name]
        else
          @system_map_planet.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:planet][:new_primary_image][:base64], image_file_name: params[:planet][:new_primary_image][:name], title: @system_map_planet.title, description: @system_map_planet.title)
        end
      end

      if @system_map_planet.update(system_map_planet_params)
        render json: @system_map_planet.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } }, settlements: {}, locations: { include: { mission_givers: {} } }, moons: {}, system_objects: {}, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :primary_image_url_full, :parent, :title_with_kind])
      else
        render json: { message: @system_map_planet.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Planet not found!' }
    end
  end

  # DELETE /system_map_planets/1
  def archive
    if @system_map_planet
      @system_map_planet.archived = true
      if @system_map_planet.save
        render json: { message: 'Planet archived!' }
      else
        render json: { message: @system_map_planet.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Planet not found!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_map_planet
      @system_map_planet = SystemMapSystemPlanetaryBody.find(params[:planet][:id])
      @system_map_planet ||= SystemMapSystemPlanetaryBody.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_map_planet_params
      params.require(:planet).permit(:title, :description, :tags, :orbits_system_id, :population_density, :economic_rating, :general_radiation, :atmospheric_height, :atmo_pressure, :tempature_max, :tempature_min, :minimum_criminality_rating, :jurisdiction_id, :faction_affiliation_id)
    end
end
