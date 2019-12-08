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

  # def add_moon
  #   @moon = SystemMapSystemPlanetaryBodyMoon.new()
  #   # :title, :description, :orbits_planet_id
  #   @moon.title = params[:moon][:title]
  #   @moon.description = params[:moon][:description]
  #   @moon.orbits_planet_id = params[:moon][:orbits_planet_id]
  #   @moon.population_density = params[:moon][:population_density]
  #   @moon.economic_rating = params[:moon][:economic_rating]
  #   @moon.general_radiation = params[:moon][:general_radiation]
  #   @moon.atmospheric_height = params[:moon][:atmospheric_height]
  #   @moon.atmo_pressure = params[:moon][:atmo_pressure]
  #   @moon.tempature_min = params[:moon][:tempature_min]
  #   @moon.tempature_max = params[:moon][:tempature_max]
  #   @moon.tempature_min = params[:moon][:tempature_min]
  #   @moon.minimum_criminality_rating = params[:moon][:minimum_criminality_rating]
  #   @moon.jurisdiction_id = params[:moon][:jurisdiction_id]

  #   @moon.discovered_by_id = current_user.id

  #   if params[:moon][:new_primary_image] != nil
  #     if @moon.primary_image != nil
  #       @moon.primary_image.image = params[:moon][:new_primary_image][:base64]
  #       @moon.primary_image.image_file_name = params[:moon][:new_primary_image][:name]
  #     else
  #       @moon.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:moon][:new_primary_image][:base64], image_file_name: params[:moon][:new_primary_image][:name], title: @moon.title, description: @moon.title)
  #     end
  #   end
  #   if @moon.save
  #     render status: 201, json: @moon.as_json(include: { jurisdiction: { include: { categories: { include: { laws: {} } } } }, flora: {}, fauna: {}, settlements: { include: { jurisdiction: { include: { categories: { include: { laws: {} } } } }, locations: { methods: [:primary_image_url, :primary_image_url_full] } }, methods: [:primary_image_url, :primary_image_url_full] }, discovered_by: { only: [], methods: [:main_character] }, system_map_images: {}, locations: { methods: [:primary_image_url, :primary_image_url_full] }, moon_types: {}, system_objects: { include: { jurisdiction: { include: { categories: { include: { laws: {} } } } }, flora: {}, fauna: {}, object_type: {}, locations: { methods: [:primary_image_url, :primary_image_url_full] } }, methods: [:primary_image_url, :primary_image_url_full] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url, :primary_image_url_full])
  #   else
  #     render status: 500, json: { message: "Moon could not be created because: #{@moon.errors.full_messages.to_sentence}" }
  #   end
  # end

  # # PATCH/PUT api/system-map/moon
  # def update_moon
  #   @moon = SystemMapSystemPlanetaryBodyMoon.find_by_id(params[:moon][:id].to_i)
  #   if @moon != nil

  #     @moon.title = params[:moon][:title]
  #     @moon.description = params[:moon][:description]
  #     @moon.population_density = params[:moon][:population_density]
  #     @moon.economic_rating = params[:moon][:economic_rating]
  #     @moon.general_radiation = params[:moon][:general_radiation]
  #     @moon.atmospheric_height = params[:moon][:atmospheric_height]
  #     @moon.atmo_pressure = params[:moon][:atmo_pressure]
  #     @moon.tempature_min = params[:moon][:tempature_min]
  #     @moon.tempature_max = params[:moon][:tempature_max]
  #     @moon.minimum_criminality_rating = params[:moon][:minimum_criminality_rating]
  #     @moon.jurisdiction_id = params[:moon][:jurisdiction_id]

  #     if params[:moon][:new_primary_image] != nil
  #       if @moon.primary_image != nil
  #         @moon.primary_image.image = params[:moon][:new_primary_image][:base64]
  #         @moon.primary_image.image_file_name = params[:moon][:new_primary_image][:name]
  #       else
  #         @moon.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:moon][:new_primary_image][:base64], image_file_name: params[:moon][:new_primary_image][:name], title: @moon.title, description: @moon.title)
  #       end
  #     end
  #     if @moon.update_attributes(moon_params)
  #       render status: 200, json: @moon.as_json(include: { jurisdiction: { include: { categories: { include: { laws: {} } } } }, flora: {}, fauna: {}, settlements: { include: { jurisdiction: { include: { categories: { include: { laws: {} } } } }, locations: { methods: [:primary_image_url, :primary_image_url_full] } }, methods: [:primary_image_url, :primary_image_url_full] }, discovered_by: { only: [], methods: [:main_character] }, system_map_images: {}, locations: { methods: [:primary_image_url, :primary_image_url_full] }, moon_types: {}, system_objects: { include: { jurisdiction: { include: { categories: { include: { laws: {} } } } }, flora: {}, fauna: {}, object_type: {}, locations: { methods: [:primary_image_url, :primary_image_url_full] } }, methods: [:primary_image_url, :primary_image_url_full] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url, :primary_image_url_full])
  #     else
  #       render status: 500, json: { message: "Moon could not be created because: #{@moon.errors.full_messages.to_sentence}"}
  #     end
  #   else
  #     #
  #     render status: 404, json: { message: "Moon not found. You lost a moon??" }
  #   end
  # end

  # # DELETE api/system-map/moon/:moon_id
  # def delete_moon
  #   begin
  #       @moon = SystemMapSystemPlanetaryBodyMoon.find_by_id(params[:moon_id].to_i)
  #       if @moon != nil
  #         @moon.archived = true
  #         if @moon.save
  #           render status: 200, json: { message: "Moon archived." }
  #         else
  #           render status: 500, json: { message: "Moon could not be archived because: #{@moon.errors.full_messages.to_sentence}"}
  #         end
  #       else
  #         render status: 404, json: { message: "Moon not found." }
  #       end
  #   rescue => e
  #     render status: 500, json: { message: "ERROR Occured: Moon could not be saved: " + e.message}
  #   end
  # end

  # GET /system_map_moons
  def index
    @system_map_moons = SystemMapSystemPlanetaryBodyMoon.where(archived: false)

    render json: @system_map_moons.to_json(include: { settlements: {}, locations: { include: { mission_givers: {} }}, system_objects: {}, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
  end

  # GET /system_map_moons/1
  def show
    if @system_map_moon
      render json: @system_map_moon.to_json(include: { settlements: {}, locations: { include: { mission_givers: {} }}, system_objects: {}, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
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
      render json: @system_map_moon.to_json(include: { settlements: {}, locations: { include: { mission_givers: {} }}, system_objects: {}, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind]), status: :created
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
        render json: @system_map_moon.to_json(include: { settlements: {}, locations: { include: { mission_givers: {} }}, system_objects: {}, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
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
