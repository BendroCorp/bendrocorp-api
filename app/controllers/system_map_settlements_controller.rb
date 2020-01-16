class SystemMapSettlementsController < ApplicationController
  before_action :set_system_map_settlement, only: [:show, :update, :archive]
  before_action :require_user
  before_action :require_member

  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23]) # editor
  end

  # all others methods should only be available to admins
  before_action only: [:archive] do |a|
    a.require_one_role([23]) # admin
  end

  # GET /system_map_settlements
  def index
    @system_map_settlements = SystemMapSystemSettlement.where(archived: false)

    render json: @system_map_settlements.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } }, locations: { include: { mission_givers: {} } }, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :primary_image_url_full, :parent, :title_with_kind])
  end

  # GET /system_map_settlements/1
  def show
    if @system_map_settlement
      render json: @system_map_settlement.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } }, locations: { include: { mission_givers: {} } }, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :primary_image_url_full, :parent, :title_with_kind])
    else
      render status: 404, json: { message: 'Settlement not found!' }
    end
  end

  # POST /system_map_settlements
  def create
    @system_map_settlement = SystemMapSystemSettlement.new(system_map_settlement_params)

    @system_map_settlement.discovered_by_id = current_user.id

    if params[:settlement][:new_primary_image] != nil
      if @system_map_settlement.primary_image != nil
        @system_map_settlement.primary_image.image = params[:settlement][:new_primary_image][:base64]
        @system_map_settlement.primary_image.image_file_name = params[:settlement][:new_primary_image][:name]
      else
        new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:settlement][:new_primary_image][:base64], image_file_name: params[:settlement][:new_primary_image][:name])
        @system_map_settlement.primary_image = new_primary_image
      end
    end

    if @system_map_settlement.save
      render json: @system_map_settlement.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } }, locations: { include: { mission_givers: {} } }, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :primary_image_url_full, :parent, :title_with_kind]), status: :created
    else
      render json: { message: @system_map_settlement.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /system_map_settlements/1
  def update
    if @system_map_settlement
      if params[:settlement][:new_primary_image] != nil
        if @system_map_settlement.primary_image != nil
          @system_map_settlement.primary_image.image = params[:settlement][:new_primary_image][:base64]
          @system_map_settlement.primary_image.image_file_name = params[:settlement][:new_primary_image][:name]
        else
          new_primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:settlement][:new_primary_image][:base64], image_file_name: params[:settlement][:new_primary_image][:name])
          @system_map_settlement.primary_image = new_primary_image
        end
      end

      if @system_map_settlement.update(system_map_settlement_params)
        render json: @system_map_settlement.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { methods: [:main_character] } } }, locations: { include: { mission_givers: {} } }, faction_affiliation: {}, jurisdiction: {} }, methods: [:kind, :primary_image_url, :primary_image_url_full, :parent, :title_with_kind])
      else
        render json: { message: @system_map_settlement.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Settlement not found!' }
    end
  end

  # DELETE /system_map_settlements/1
  def archive
    if @system_map_settlement
      @system_map_settlement.archived = true
      if @system_map_settlement.save
        render json: { message: 'Settlement archived!' }
      else
        render json: { message: @system_map_settlement.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Settlement not found!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_map_settlement
      @system_map_settlement = SystemMapSystemSettlement.find(params[:settlement][:id])
      @system_map_settlement ||= SystemMapSystemSettlement.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def system_map_settlement_params
      params.require(:settlement).permit(:title, :description, :tags, :coordinates, :faction_affiliation_id, :on_planet_id, :on_moon_id, :jurisdiction_id, :faction_affiliation_id)
    end
end
