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
    # old code
    # @system_map_image.image = params[:image][:new_image][:base64]
    # @system_map_image.image_file_name = params[:image][:new_image][:name]
    # @system_map_image.created_by_id = current_user.id

    # get the data
    data = params[:image][:new_image][:base64].split(',')[1]

    # create and perform a base resize on the image
    image = MiniMagick::Image.read(StringIO.new(Base64.decode64(data)))
    pipeline = ImageProcessing::MiniMagick.source(image)
    resized_image = pipeline.convert('png').resize_to_fit!(1920, 1080)

    # transform the data into the ActiveStorage blob
    image_blob = ActiveStorage::Blob.create_after_upload!(
      io: File.open(resized_image.path),
      filename: "#{@star_object.id}.png",
      content_type: 'image/png'
    )

    # attach the image to the object
    @system_map_image.primary_image.image.attach(image_blob)

    # create the new object
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
      params.require(:image).permit(:title, :description, :is_default_image, :of_star_object_id, :of_system_id, :of_planet_id, :of_moon_id, :of_system_object_id, :of_location_id, :of_settlement_id, :of_gravity_well_id, :of_mission_giver_id)
    end
end
