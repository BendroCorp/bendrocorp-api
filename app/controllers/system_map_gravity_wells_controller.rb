class SystemMapGravityWellsController < ApplicationController
  before_action :set_system_map_gravity_well, only: [:show, :update, :archive]
  before_action :require_user
  before_action :require_member

  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23]) # editor
  end

  # all others methods should only be available to admins
  before_action only: [:archive] do |a|
    a.require_one_role([23]) # admin
  end

  # def delete_gravity_well
  #   begin
  #       @obj = SystemMapSystemGravityWell.find_by_id(params[:gravity_well_id].to_i)
  #       if @obj != nil
  #         if @obj.destroy
  #           render status: 200, json: { message: "Success" }
  #         else
  #           render status: 500, json: { message: "ERROR Occured: Gravity well could not be removed."}
  #         end
  #       else
  #         render status: 404, json: { message: "Gravity well not found." }
  #       end
  #   rescue => e
  #     render status: 500, json: { message: "ERROR Occured: New system could not be deleted: " + e.message}
  #   end
  # end

  # GET /system_map_gravity_wells
  def index
    @system_map_gravity_wells = SystemMapSystemGravityWell.where(archived: false)

    render json: @system_map_gravity_wells.as_json(methods: [:kind, :parent], include: { gravity_well_type: {}, luminosity_class: {} })
  end

  # GET /system_map_gravity_wells/1
  def show
    if @system_map_gravity_well
      render json: @system_map_gravity_well
    else
      render status: 404, json: { message: 'Gravity well not found!' }
    end
  end

  # POST /system_map_gravity_wells
  def create
    @system_map_gravity_well = SystemMapSystemGravityWell.new(system_map_gravity_well_params)

    @system_map_gravity_well.discovered_by_id = current_user.id

    if params[:gravity_well][:new_primary_image] != nil
      if @system_map_gravity_well.primary_image != nil
        @system_map_gravity_well.primary_image.image = params[:gravity_well][:new_primary_image][:base64]
        @system_map_gravity_well.primary_image.image_file_name = params[:gravity_well][:new_primary_image][:name]
      else
        new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:gravity_well][:new_primary_image][:base64], image_file_name: params[:gravity_well][:new_primary_image][:name])
        @system_map_gravity_well.primary_image = new_primary_image
      end
    end

    if @system_map_gravity_well.save
      render json: @system_map_gravity_well.as_json(methods: [:kind, :parent], include: { gravity_well_type: {}, luminosity_class: {} }), status: :created
    else
      render json: { message: @system_map_gravity_well.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_map_gravity_wells/1
  def update
    if @system_map_gravity_well

      if params[:gravity_well][:new_primary_image] != nil
        if @system_map_gravity_well.primary_image != nil
          @system_map_gravity_well.primary_image.image = params[:gravity_well][:new_primary_image][:base64]
          @system_map_gravity_well.primary_image.image_file_name = params[:gravity_well][:new_primary_image][:name]
        else
          new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:gravity_well][:new_primary_image][:base64], image_file_name: params[:gravity_well][:new_primary_image][:name])
          @system_map_gravity_well.primary_image = new_primary_image
        end
      end

      if @system_map_gravity_well.update(system_map_gravity_well_params)
        render json: @system_map_gravity_well.as_json(methods: [:kind, :parent], include: { gravity_well_type: {}, luminosity_class: {} })
      else
        render json: { message: @system_map_gravity_well.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Gravity well not found!' }
    end
  end

  # DELETE /system_map_gravity_wells/1
  def archive
    if @system_map_gravity_well
      @system_map_gravity_well.archived = true
      if @system_map_gravity_well.save
        render json: { message: 'Gravity well archived!' }
      else
        render json: { message: @system_map_gravity_well.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Gravity well not found!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_map_gravity_well
      @system_map_gravity_well = SystemMapSystemGravityWell.find(params[:gravity_well][:id])
      @system_map_gravity_well ||= SystemMapSystemGravityWell.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_map_gravity_well_params
      params.require(:gravity_well).permit(:title, :description, :tags, :system_id, :gravity_well_type_id, :luminosity_class_id)
    end
end
