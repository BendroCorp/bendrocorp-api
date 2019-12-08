class SystemMapImagesController < ApplicationController
  before_action :set_system_map_image, only: [:show, :update, :destroy]
  before_action :require_user
  before_action :require_member

  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23]) # editor & admin
  end

  # all others methods should only be available to admins
  before_action only: [:archive] do |a|
    a.require_one_role([23]) # admin
  end

  # POST api/system-map/image
  # def add_system_image
  #   begin
  #     @image = SystemMapImage.new(system_image_params)
  #     @image.image = params[:image][:new_image][:base64]
  #     @image.image_file_name = params[:image][:new_image][:name]

  #     @image.created_by_id = current_user.id

  #     #If its the system objects first image make it the default image
  #     #:of_system_id, :of_planet_id, :of_moon_id, :of_system_object_id, :of_settlement_id, :of_location_id, :of_gravity_well_id
  #     # if @image.of_system_id != nil && @image.of_system_id != 0
  #     #   @image.is_default_image = true unless @image.of_system.system_map_images.count > 0
  #     #
  #     # elsif @image.of_planet_id != nil && @image.of_planet_id != 0
  #     #   @image.is_default_image = true unless @image.of_planet_id.system_map_images.count > 0
  #     #
  #     # elsif @image.of_moon_id != nil && @image.of_moon_id != 0
  #     #   @image.is_default_image = true unless @image.of_moon_id.system_map_images.count > 0
  #     #
  #     # elsif @image.of_system_object_id != nil && @image.of_system_object_id != 0
  #     #   @image.is_default_image = true unless @image.of_system_object_id.system_map_images.count > 0
  #     #
  #     # elsif @image.of_location_id != nil && @image.of_location_id != 0
  #     #   @image.is_default_image = true unless @image.of_location_id.system_map_images.count > 0
  #     #
  #     # elsif @image.of_gravity_well_id != nil && @image.of_gravity_well_id != 0
  #     #   @image.is_default_image = true unless @image.of_gravity_well_id.system_map_images.count > 0
  #     # end

  #     if @image.save
  #       render status: 200, json: @image.as_json(include: { created_by: { only: [:id, :username], methods: [:main_character] } })
  #     else
  #       render status: 500, json: {message: "System Image could not be created because: #{@image.errors.full_messages.to_sentence}"}
  #     end
  #   rescue => e
  #     render status: 500, json: { message: "ERROR Occured: New image could not be saved: " + e.message}
  #   end
  # end

  # # PATCH|PUT api/system-map/image
  # def update_system_image
  #   @image = SystemMapImage.find_by_id(params[:image][:id])
  #   if @image
  #     if params[:image][:new_image]
  #       @image.image = params[:image][:new_image][:base64]
  #       @image.image_file_name = params[:image][:new_image][:name]
  #     end

  #     if @image.update_attributes(system_image_params)
  #       render status: 200, json: @image.as_json(include: { created_by: { only: [:id, :username], methods: [:main_character] } })
  #     else
  #       render status: 500, json: {message: "System Image could not be created because: #{@image.errors.full_messages.to_sentence}"}
  #     end
  #   else
  #     render status: 404, json: { message: "System image not found" }
  #   end
  # end

  # # DELETE api/system-map/image/:image_id
  # def delete_system_image
  #   begin
  #     @image = SystemMapImage.find_by_id(params[:image_id].to_i)
  #     if @image
  #       if @image.destroy
  #         render status: 200, json: { message: 'Image added'}
  #       else
  #         render status: 500, json: {message: "Error Occured: Image could not be deleted."}
  #       end
  #     else
  #       render status: 404, json: { message: "System image not found" }
  #     end
  #   rescue => e
  #     render status: 500, json: { message: "ERROR Occured: Image could not be deleted: " + e.message }
  #   end
  # end

  # POST /system_map_images
  def create
    @system_map_image = SystemMapImage.new(system_map_image_params)

    @system_map_image = SystemMapImage.new(system_image_params)
    @system_map_image.image = params[:image][:new_image][:base64]
    @system_map_image.image_file_name = params[:image][:new_image][:name]
    @system_map_image.created_by_id = current_user.id

    if @system_map_image.save
      render json: @system_map_image, status: :created, location: @system_map_image
    else
      render json: { message: @system_map_image.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_map_images/1
  def update
    if @system_map_image.update(system_map_image_params)
      render json: @system_map_image
    else
      render json: { message: @system_map_image.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # DELETE /system_map_images/1
  def destroy
    if @system_map_image
      if @system_map_image.destroy
        render json: { message: 'System map image deleted.' }
      else
        render json: { message: @system_map_image.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Not found!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_map_image
      @system_map_image = SystemMapImage.find(params[:system_map_image][:id])
      @system_map_image ||= SystemMapImage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_map_image_params
      params.require(:image).permit(:title, :description, :created_by, :is_default_image, :of_system, :of_planet, :of_moon, :of_system_object, :of_location, :of_settlement, :of_gravity_well, :of_mission_giver)
    end
end
