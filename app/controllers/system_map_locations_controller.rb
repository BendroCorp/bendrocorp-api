class SystemMapLocationsController < ApplicationController
  before_action :set_system_map_location, only: [:show, :update, :archive]
  before_action :require_user
  before_action :require_member

  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23]) # editor
  end

  # all others methods should only be available to admins
  before_action only: [:archive] do |a|
    a.require_one_role([23]) # admin
  end

  # def add_location
  #   #@locations = SystemMapSystemPlanetaryBodyLocation.create(location_params)
  #   @location = SystemMapSystemPlanetaryBodyLocation.new

  #   if params[:location][:new_primary_image] != nil
  #     if @location.primary_image != nil
  #       @location.primary_image.image = params[:location][:new_primary_image][:base64]
  #       @location.primary_image.image_file_name = params[:location][:new_primary_image][:name]
  #     else
  #       @location.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:location][:new_primary_image][:base64], image_file_name: params[:location][:new_primary_image][:name], title: @location.title, description: @location.title)
  #     end
  #   end

  #   @location.title = params[:location][:title]
  #   @location.description = params[:location][:description]
  #   @location.on_planet_id = params[:location][:on_planet_id]
  #   @location.on_moon_id = params[:location][:on_moon_id]
  #   @location.on_system_object_id = params[:location][:on_system_object_id]
  #   @location.on_settlement_id = params[:location][:on_settlement_id]
  #   @location.discovered_by_id = current_user.id

  #   if @location.save
  #     render status: 200, json: @location.as_json(methods: [:primary_image_url, :primary_image_url_full])
  #   else
  #     render status: 500, json: { message: "Location could not be created because: #{@location.errors.full_messages.to_sentence}"}
  #   end
  # end

  # def update_location
  #   @location = SystemMapSystemPlanetaryBodyLocation.find_by_id(params[:location][:id].to_i)
  #   if @location != nil

  #     # check for a new primary image
  #     if params[:location][:new_primary_image] != nil
  #       if @location.primary_image != nil
  #         @location.primary_image.image = params[:location][:new_primary_image][:base64]
  #         @location.primary_image.image_file_name = params[:location][:new_primary_image][:name]
  #       else
  #         new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:location][:new_primary_image][:base64], image_file_name: params[:location][:new_primary_image][:name])
  #         @location.primary_image = new_primary_image
  #       end
  #     end

  #     @location.title = params[:location][:title]
  #     @location.description = params[:location][:description]
  #     @location.on_planet_id = params[:location][:on_planet_id]
  #     @location.on_moon_id = params[:location][:on_moon_id]
  #     @location.on_system_object_id = params[:location][:on_system_object_id]
  #     @location.on_settlement_id = params[:location][:on_settlement_id]

  #     if @location.save
  #       render status: 200, json: @location.as_json(methods: [:primary_image_url, :primary_image_url_full])
  #     else
  #       render status: 500, json: { message: "Location could not be updated because: #{@location.errors.full_messages.to_sentence}"}
  #     end
  #   else
  #     render status: 404, json: { message: "Location not found." }
  #   end
  # end

  # def delete_location
  #   @location = SystemMapSystemPlanetaryBodyLocation.find_by_id(params[:location_id].to_i)
  #   if @location != nil
  #     if @location.destroy
  #       render status: 200, json: { message: "Success" }
  #     else
  #       render status: 500, json: { message: "Location could not be archived because: #{@location.errors.full_messages.to_sentence}" }
  #     end
  #   else
  #     render status: 404, json: { message: "Settlement not found." }
  #   end
  # end

  # GET /system_map_locations
  def index
    @system_map_locations = SystemMapSystemPlanetaryBodyLocation.where(archived: false)

    render json: @system_map_locations.to_json(include: { mission_givers: {}, faction_affiliation: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
  end

  # GET /system_map_locations/1
  def show
    if @system_map_location
      render json: @system_map_location.to_json(include: { mission_givers: {}, faction_affiliation: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
    else
      render status: 404, json: { message: 'Location not found!' }
    end
  end

  # POST /system_map_locations
  def create
    @system_map_location = SystemMapSystemPlanetaryBodyLocation.new(system_map_location_params)

    @system_map_location.discovered_by_id = current_user.id

    if params[:location][:new_primary_image] != nil
      if @system_map_location.primary_image != nil
        @system_map_location.primary_image.image = params[:location][:new_primary_image][:base64]
        @system_map_location.primary_image.image_file_name = params[:location][:new_primary_image][:name]
      else
        new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:location][:new_primary_image][:base64], image_file_name: params[:location][:new_primary_image][:name])
        @system_map_location.primary_image = new_primary_image
      end
    end

    if @system_map_location.save
      render json: @system_map_location.to_json(include: { mission_givers: {}, faction_affiliation: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind]), status: :created
    else
      render json: { message: @system_map_location.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_map_locations/1
  def update
    if @system_map_location

      if params[:location][:new_primary_image] != nil
        if @system_map_location.primary_image != nil
          @system_map_location.primary_image.image = params[:location][:new_primary_image][:base64]
          @system_map_location.primary_image.image_file_name = params[:location][:new_primary_image][:name]
        else
          new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:location][:new_primary_image][:base64], image_file_name: params[:location][:new_primary_image][:name])
          @system_map_location.primary_image = new_primary_image
        end
      end

      if @system_map_location.update(system_map_location_params)
        render json: @system_map_location.to_json(include: { mission_givers: {}, faction_affiliation: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
      else
        render json: { message: @system_map_location.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Location not found!' }
    end
  end

  # DELETE /system_map_locations/1
  def archive
    if @system_map_location
      @system_map_location.archived = true
      if @system_map_location.save
        render json: { message: 'Archived location!' }
      else
        render json: { message: @system_map_location.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Location not found!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_map_location
      @system_map_location = SystemMapSystemPlanetaryBodyLocation.find(params[:location][:id])
      @system_map_location ||= SystemMapSystemPlanetaryBodyLocation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_map_location_params
      params.require(:location).permit(:title, :description, :tags, :coordinates, :faction_affiliation_id, :on_planet_id, :on_moon_id, :on_system_object_id, :on_settlement_id, :location_type_id, :faction_affiliation_id)
    end
end
