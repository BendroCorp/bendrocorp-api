class SystemMapJumpPointsController < ApplicationController
  before_action :set_system_map_jump_point, only: [:show, :update, :archive]
  before_action :require_user
  before_action :require_member

  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23]) # editor
  end

  # all others methods should only be available to admins
  before_action only: [:archive] do |a|
    a.require_one_role([23]) # admin
  end

  # GET /system_map_jump_points
  def index
    @system_map_jump_points = SystemMapSystemConnection.where(archived: false)

    render json: @system_map_jump_points.as_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } }, system_one: {}, system_two: {}, connection_size: {}, connection_status: {} }, methods: [:kind, :primary_image_one_url, :primary_image_one_url_full, :primary_image_two_url, :primary_image_url_two_full])
  end

  # GET /system_map_jump_points/1
  def show
    if @system_map_jump_point
      render json: @system_map_jump_point.as_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } }, system_one: {}, system_two: {}, connection_size: {}, connection_status: {} }, methods: [:kind, :primary_image_one_url, :primary_image_one_url_full, :primary_image_two_url, :primary_image_url_two_full])
    else
      render status: 404, json: { message: 'Jump point not found!' }
    end
  end

  # POST /system_map_jump_points
  def create
    @system_map_jump_point = SystemMapSystemConnection.new(system_map_jump_point_params)

    @system_map_jump_point.discovered_by_id = current_user.id

    if params[:jump_point][:new_primary_image_one] != nil
      if @system_map_jump_point.primary_image != nil
        @system_map_jump_point.primary_image.image = params[:jump_point][:new_primary_image_one][:base64]
        @system_map_jump_point.primary_image.image_file_name = params[:jump_point][:new_primary_image_one][:name]
      else
        @system_map_jump_point.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:jump_point][:new_primary_image_one][:base64], image_file_name: params[:jump_point][:new_primary_image_one][:name], title: @system_map_jump_point.title, description: @system_map_jump_point.title)
      end
    end

    if params[:jump_point][:new_primary_image_two] != nil
      if @system_map_jump_point.primary_image != nil
        @system_map_jump_point.primary_image.image = params[:jump_point][:new_primary_image_two][:base64]
        @system_map_jump_point.primary_image.image_file_name = params[:jump_point][:new_primary_image_two][:name]
      else
        @system_map_jump_point.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:jump_point][:new_primary_image_two][:base64], image_file_name: params[:jump_point][:new_primary_image_two][:name], title: @system_map_jump_point.title, description: @system_map_jump_point.title)
      end
    end

    if @system_map_jump_point.save
      render json: @system_map_jump_point.as_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } }, system_one: {}, system_two: {}, connection_size: {}, connection_status: {} }, methods: [:kind, :primary_image_one_url, :primary_image_one_url_full, :primary_image_two_url, :primary_image_url_two_full])
    else
      render json: { message: @system_map_jump_point.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_map_jump_points/1
  def update
    if @system_map_jump_point

      if params[:jump_point][:new_primary_image_one] != nil
        if @system_map_jump_point.primary_image != nil
          @system_map_jump_point.primary_image.image = params[:jump_point][:new_primary_image_one][:base64]
          @system_map_jump_point.primary_image.image_file_name = params[:jump_point][:new_primary_image_one][:name]
        else
          @system_map_jump_point.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:jump_point][:new_primary_image_one][:base64], image_file_name: params[:jump_point][:new_primary_image_one][:name], title: @system_map_jump_point.title, description: @system_map_jump_point.title)
        end
      end

      if params[:jump_point][:new_primary_image_two] != nil
        if @system_map_jump_point.primary_image != nil
          @system_map_jump_point.primary_image.image = params[:jump_point][:new_primary_image_two][:base64]
          @system_map_jump_point.primary_image.image_file_name = params[:jump_point][:new_primary_image_two][:name]
        else
          @system_map_jump_point.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:jump_point][:new_primary_image_two][:base64], image_file_name: params[:jump_point][:new_primary_image_two][:name], title: @system_map_jump_point.title, description: @system_map_jump_point.title)
        end
      end

      if @system_map_jump_point.update(system_map_jump_point_params)
        render json: @system_map_jump_pointz.as_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } }, system_one: {}, system_two: {}, connection_size: {}, connection_status: {} }, methods: [:kind, :primary_image_one_url, :primary_image_one_url_full, :primary_image_two_url, :primary_image_url_two_full])
      else
        render json: { message: @system_map_jump_point.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Jump point not found!' }
    end
  end

  # DELETE /system_map_jump_points/1
  def archive
    if @system_map_jump_point
      if @system_map_jump_point.save
        render json: { message: 'Jump point archived!' }
      else
        render json: { message: @system_map_jump_point.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Jump point not found!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_map_jump_point
      @system_map_jump_point = SystemMapSystemConnection.find(params[:jump_point][:id])
      @system_map_jump_point ||= SystemMapSystemConnection.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_map_jump_point_params
      params.require(:jump_point).permit(:title, :description, :tags, :connection_size_id, :connection_status_id, :system_one_id, :system_two_id)
    end
end
