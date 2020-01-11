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

  # POST /system_map_images
  def create
    @system_map_image = SystemMapImage.new(system_map_image_params)

    @system_map_image = SystemMapImage.new(system_image_params)
    @system_map_image.image = params[:image][:new_image][:base64]
    @system_map_image.image_file_name = params[:image][:new_image][:name]
    @system_map_image.created_by_id = current_user.id

    if @system_map_image.save
      render json: @system_map_image, status: :created
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
