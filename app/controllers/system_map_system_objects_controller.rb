class SystemMapSystemObjectsController < ApplicationController
  before_action :set_system_map_system_object, only: [:show, :update, :archive]
  before_action :require_user
  before_action :require_member

  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23]) # editor
  end

  # all others methods should only be available to admins
  before_action only: [:archive] do |a|
    a.require_one_role([23]) # admin
  end

  # def add_system_object
  #   begin
  #       @system_map_system_object = SystemMapSystemObject.new()
  #       @system_map_system_object.title = params[:system_object][:title]
  #       @system_map_system_object.description = params[:system_object][:description]
  #       @system_map_system_object.object_type_id = params[:system_object][:object_type_id]
  #       @system_map_system_object.orbits_planet_id = params[:system_object][:orbits_planet_id]
  #       @system_map_system_object.orbits_moon_id = params[:system_object][:orbits_moon_id]
  #       @system_map_system_object.jurisdiction_id = params[:system_object][:jurisdiction_id]

  #       @system_map_system_object.discovered_by_id = current_user.id

  #       if params[:system_object][:new_primary_image] != nil
  #         if @system_map_system_object.primary_image != nil
  #           @system_map_system_object.primary_image.image = params[:system_object][:new_primary_image][:base64]
  #           @system_map_system_object.primary_image.image_file_name = params[:system_object][:new_primary_image][:name]
  #         else
  #           @system_map_system_object.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:system_object][:new_primary_image][:base64], image_file_name: params[:system_object][:new_primary_image][:name], title: @system_map_system_object.title, description: @system_map_system_object.title)
  #         end
  #       end

  #       if @system_map_system_object.save
  #         render status: 200, json: @system_map_system_object.as_json(include: { jurisdiction: { include: { categories: { include: { laws: {} } } } }, flora: {}, fauna: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } }, object_type: {}, locations: { methods: [:primary_image_url, :primary_image_url_full] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url, :primary_image_url_full])
  #       else
  #         render status: 500, json: { message: "System object could not be created because: #{@system_map_system_object.errors.full_messages.to_sentence}"}
  #       end
  #   rescue => e
  #     render status: 500, json: { message: "ERROR Occured: New system could not be saved: " + e.message}
  #   end
  # end

  # def update_system_object
  #   begin
  #       @system_map_system_object = SystemMapSystemObject.find_by_id(params[:system_object][:id].to_i)
  #       if @system_map_system_object != nil
  #         @system_map_system_object.title = params[:system_object][:title]
  #         @system_map_system_object.description = params[:system_object][:description]
  #         @system_map_system_object.object_type_id = params[:system_object][:object_type_id]
  #         @system_map_system_object.orbits_planet_id = params[:system_object][:orbits_planet_id]
  #         @system_map_system_object.orbits_moon_id = params[:system_object][:orbits_moon_id]
  #         @system_map_system_object.jurisdiction_id = params[:system_object][:jurisdiction_id]
  #         if params[:system_object][:new_primary_image] != nil
  #           if @system_map_system_object.primary_image != nil
  #             @system_map_system_object.primary_image.image = params[:system_object][:new_primary_image][:base64]
  #             @system_map_system_object.primary_image.image_file_name = params[:system_object][:new_primary_image][:name]
  #           else
  #             @system_map_system_object.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:system_object][:new_primary_image][:base64], image_file_name: params[:system_object][:new_primary_image][:name], title: @system_map_system_object.title, description: @system_map_system_object.title)
  #           end
  #         end

  #         @system_map_system_object.discovered_by_id = current_user.id

  #         if @system_map_system_object.save
  #           render status: 200, json: @system_map_system_object.as_json(include: { jurisdiction: { include: { categories: { include: { laws: {} } } } }, flora: {}, fauna: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } }, object_type: {}, locations: { methods: [:primary_image_url, :primary_image_url_full] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url, :primary_image_url_full])
  #         else
  #           render status: 500, json: { message: "System object could not be updated because: #{@system_map_system_object.errors.full_messages.to_sentence}"}
  #         end
  #       else
  #         render status: 404, json: { message: "System object not found." }
  #       end
  #   rescue => e
  #     render status: 500, json: { message: "ERROR Occured: New system could not be saved: " + e.message}
  #   end
  # end

  # def delete_system_object
  #   begin
  #       @system_map_system_object = SystemMapSystemObject.find_by_id(params[:so_id].to_i)
  #       if @system_map_system_object != nil
  #         @system_map_system_object.archived = true
  #         if @system_map_system_object.save
  #           render status: 200, json: { message: "Success" }
  #         else
  #           render status: 500, json: { message: "System object could not be archived because: #{@system_map_system_object.errors.full_messages.to_sentence}"}
  #         end
  #       else
  #         render status: 404, json: { message: "Gravity well not found." }
  #       end
  #   rescue => e
  #     render status: 500, json: { message: "ERROR Occured: New system could not be saved: " + e.message}
  #   end
  # end

  # GET /system_map_system_objects
  def index
    @system_map_system_objects = SystemMapSystemObject.where(archived: false)

    render json: @system_map_system_objects.to_json(include: { object_type: {}, locations: { include: { mission_givers: {} } }, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
  end

  # GET /system_map_system_objects/1
  def show
    if @system_map_system_object
      render json: @system_map_system_object.to_json(include: { object_type: {}, locations: { include: { mission_givers: {} } }, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
    else
      render status: 404, json: { message: 'System object not found!' }
    end
  end

  # POST /system_map_system_objects
  def create
    @system_map_system_object = SystemMapSystemObject.new(system_map_system_object_params)

    @system_map_system_object.discovered_by_id = current_user.id

    if params[:system_object][:new_primary_image] != nil
      if @system_map_system_object.primary_image != nil
        @system_map_system_object.primary_image.image = params[:system_object][:new_primary_image][:base64]
        @system_map_system_object.primary_image.image_file_name = params[:system_object][:new_primary_image][:name]
      else
        @system_map_system_object.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:system_object][:new_primary_image][:base64], image_file_name: params[:system_object][:new_primary_image][:name], title: @system_map_system_object.title, description: @system_map_system_object.title)
      end
    end

    if @system_map_system_object.save
      render json: @system_map_system_object.to_json(include: { object_type: {}, locations: { include: { mission_givers: {} } }, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind]), status: :created
    else
      render json: { message: @system_map_system_object.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_map_system_objects/1
  def update
    if @system_map_system_object

      if params[:system_object][:new_primary_image] != nil
        if @system_map_system_object.primary_image != nil
          @system_map_system_object.primary_image.image = params[:system_object][:new_primary_image][:base64]
          @system_map_system_object.primary_image.image_file_name = params[:system_object][:new_primary_image][:name]
        else
          @system_map_system_object.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:system_object][:new_primary_image][:base64], image_file_name: params[:system_object][:new_primary_image][:name], title: @system_map_system_object.title, description: @system_map_system_object.title)
        end
      end

      if @system_map_system_object.update(system_map_system_object_params)
        render json: @system_map_system_object.to_json(include: { object_type: {}, locations: { include: { mission_givers: {} } }, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :parent, :title_with_kind])
      else
        render json: { message: @system_map_system_object.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'System object not found!' }
    end
  end

  # DELETE /system_map_system_objects/1
  def archive
    if @system_map_system_object
      @system_map_system_object.archived = true
      if @system_map_system_object.destroy
        render json: { message: 'System object archived!' }
      else
        render json: { message: @system_map_system_object.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'System object not found!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_map_system_object
      @system_map_system_object = SystemMapSystemObject.find(params[:system_object][:id])
      @system_map_system_object ||= SystemMapSystemObject.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_map_system_object_params
      params.require(:system_object).permit(:title, :description, :tags, :object_type_id, :orbits_system_id, :orbits_planet_id, :orbits_moon_id, :faction_affiliation_id)
    end
end
