class SystemMapFlorasController < ApplicationController
  before_action :set_system_map_flora, only: [:show, :update, :archive]
  before_action :require_user
  before_action :require_member

  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23]) # editor
  end

  # all others methods should only be available to admins
  before_action only: [:archive] do |a|
    a.require_one_role([23]) # admin
  end

  # def add_flora
  #   #SystemMapFlora
  #   #SsaveCount = 0
  #   #params[:flora].each do |loc|
  #   @flora = SystemMapFlora.new

  #   if params[:flora][:new_primary_image] != nil
  #     new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: "data:#{params[:flora][:new_primary_image][:filetype]};base64,#{params[:flora][:new_primary_image][:base64]}", image_file_name: params[:flora][:new_primary_image][:filename])
  #     @flora.primary_image = new_primary_image
  #   else
  #     @flora.primary_image = SystemMapImage.new
  #   end

  #   @flora.title = params[:flora][:title]
  #   @flora.description = params[:flora][:description]
  #   @flora.on_planet_id = params[:flora][:on_planet_id]
  #   @flora.on_moon_id = params[:flora][:on_moon_id]
  #   @flora.on_system_object_id = params[:flora][:on_system_object_id]
  #   @flora.discovered_by_id = current_user.id

  #   if @flora.save
  #     render status: 200, json: { message: "Success" }
  #   else
  #     render status: 500, json: { message: "ERROR Occured: New settlement could not be saved."}
  #   end
  # end

  # def update_flora
  #   @flora = SystemMapFlora.find_by_id(params[:flora][:id])
  #   if @flora != nil
  #     if params[:flora][:new_primary_image] != nil
  #       new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: "data:#{params[:flora][:new_primary_image][:filetype]};base64,#{params[:flora][:new_primary_image][:base64]}", image_file_name: params[:flora][:new_primary_image][:filename])
  #       @flora.primary_image = new_primary_image
  #     else
  #       @flora.primary_image = SystemMapImage.new
  #     end

  #     @flora.title = params[:flora][:title]
  #     @flora.description = params[:flora][:description]
  #     @flora.on_planet_id = params[:flora][:on_planet_id]
  #     @flora.on_moon_id = params[:flora][:on_moon_id]
  #     @flora.on_system_object_id = params[:flora][:on_system_object_id]

  #     if @flora.save
  #       render status: 200, json: { message: "Success" }
  #     else
  #       render status: 500, json: { message: "ERROR Occured: New settlement could not be saved."}
  #     end
  #   else
  #     render status: 404, json: { message: "Flora not found."}
  #   end
  # end

  # def delete_flora
  #   @flora = SystemMapFlora.find_by_id(params[:fauna_id])
  #   if @flora != nil
  #     if @flora.destroy
  #       render status: 200, json: { message: "Success" }
  #     else
  #       render status: 500, json: { message: "ERROR Occured: New settlement could not be saved."}
  #     end
  #   else
  #     render status: 404, json: { message: "Flora not found."}
  #   end
  # end

  # GET /system_map_floras
  def index
    @system_map_floras = SystemMapFlora.where(archived: false)

    render json: @system_map_floras
  end

  # GET /system_map_floras/1
  def show
    if @system_map_flora
      render json: @system_map_flora
    else
      render status: 404, json: { message: "Flora not found." }
    end
  end

  # POST /system_map_floras
  def create
    @system_map_flora = SystemMapFlora.new(system_map_flora_params)

    @system_map_flora.discovered_by_id = current_user.id

    if params[:flora][:new_primary_image] != nil
      if @system_map_flora.primary_image != nil
        @system_map_flora.primary_image.image = params[:flora][:new_primary_image][:base64]
        @system_map_flora.primary_image.image_file_name = params[:flora][:new_primary_image][:name]
      else
        new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:flora][:new_primary_image][:base64], image_file_name: params[:flora][:new_primary_image][:name])
        @system_map_flora.primary_image = new_primary_image
      end
    end

    if @system_map_flora.save
      render json: @system_map_flora, status: :created
    else
      render json: { message: @system_map_flora.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_map_floras/1
  def update
    if @system_map_flora

      if params[:flora][:new_primary_image] != nil
        if @system_map_flora.primary_image != nil
          @system_map_flora.primary_image.image = params[:flora][:new_primary_image][:base64]
          @system_map_flora.primary_image.image_file_name = params[:flora][:new_primary_image][:name]
        else
          new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:flora][:new_primary_image][:base64], image_file_name: params[:flora][:new_primary_image][:name])
          @system_map_flora.primary_image = new_primary_image
        end
      end

      if @system_map_flora.update(system_map_flora_params)
        render json: @system_map_flora
      else
        render json: { message: @system_map_flora.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Flora not found.' }
    end
  end

  # DELETE /system_map_floras/1
  def archive
    if @system_map_flora
      @system_map_flora.archived = true
      if @system_map_flora.save
        render json: { message: 'Flora archived!' }
      else
        render json: { message: @system_map_flora.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Flora not found.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_map_flora
      @system_map_flora = SystemMapFlora.find(params[:flora][:id])
      @system_map_flora ||= SystemMapFlora.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_map_flora_params
      params.require(:flora).permit(:title, :description, :tags, :on_planet_id, :on_moon_id, :on_system_object_id,)
    end
end
