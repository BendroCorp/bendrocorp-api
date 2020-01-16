class SystemMapFaunasController < ApplicationController
  before_action :set_system_map_fauna, only: [:show, :update, :archive]
  before_action :require_user
  before_action :require_member

  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23]) # editor
  end

  # all others methods should only be available to admins
  before_action only: [:archive] do |a|
    a.require_one_role([23]) # admin
  end

  # GET /system_map_faunas
  def index
    @system_map_faunas = SystemMapFauna.where(archived: false)

    render json: @system_map_faunas.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } } }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
  end

  # GET /system_map_faunas/1
  def show
    if @system_map_fauna
      render json: @system_map_fauna.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } } }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
    else
      render status: 404, json: { message: "Fauna not found."}
    end
  end

  # POST /system_map_faunas
  def create
    @system_map_fauna = SystemMapFauna.new(system_map_fauna_params)

    @system_map_fauna.discovered_by_id = current_user.id

    if params[:fauna][:new_primary_image] != nil
      if @system_map_fauna.primary_image != nil
        @system_map_fauna.primary_image.image = params[:fauna][:new_primary_image][:base64]
        @system_map_fauna.primary_image.image_file_name = params[:fauna][:new_primary_image][:name]
      else
        new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:fauna][:new_primary_image][:base64], image_file_name: params[:fauna][:new_primary_image][:name])
        @system_map_fauna.primary_image = new_primary_image
      end
    end

    if @system_map_fauna.save
      render json: @system_map_fauna.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } } }, methods: [:kind, :primary_image_url, :parent, :title_with_kind]), status: :created
    else
      render json: { message: @system_map_fauna.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_map_faunas/1
  def update
    if @system_map_fauna

      if params[:fauna][:new_primary_image] != nil
        if @system_map_fauna.primary_image != nil
          @system_map_fauna.primary_image.image = params[:fauna][:new_primary_image][:base64]
          @system_map_fauna.primary_image.image_file_name = params[:fauna][:new_primary_image][:name]
        else
          new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:fauna][:new_primary_image][:base64], image_file_name: params[:fauna][:new_primary_image][:name])
          @system_map_fauna.primary_image = new_primary_image
        end
      end

      if @system_map_fauna.update(system_map_fauna_params)
        render json: @system_map_fauna.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } } }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
      else
        render json: { message: @system_map_fauna.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: "Fauna not found."}
    end
  end

  # DELETE /system_map_faunas/1
  def archive
    if @system_map_fauna
      @system_map_fauna.archived = true
      if @system_map_fauna.save
        render json: { message: 'Fauna archived!' }
      else
        render json: { message: @system_map_fauna.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: "Fauna not found."}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_map_fauna
      @system_map_fauna = SystemMapFauna.find(params[:fauna][:id])
      @system_map_fauna ||= SystemMapFauna.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_map_fauna_params
      params.require(:fauna).permit(:title, :description, :tags, :on_planet_id, :on_moon_id, :on_system_object_id, :is_predator, :is_sentient, :density)
    end
end
