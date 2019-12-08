class FactionAffiliationController < ApplicationController
  before_action :set_faction_affiliation, only: [:update, :archive]
  before_action :require_user
  before_action :require_member

  before_action except: [:list] do |a|
    a.require_one_role([51]) # faction admin
  end

  # GET api/factions
  def list
    render json: FactionAffiliation.all
  end

  # POST api/factions
  def create
    @faction_affiliation = FactionAffiliation.new(faction_affiliation_params)

    if params[:faction][:new_primary_image] != nil
      if @faction_affiliation.primary_image != nil
        @faction_affiliation.primary_image.image = params[:faction][:new_primary_image][:base64]
        @faction_affiliation.primary_image.image_file_name = params[:faction][:new_primary_image][:name]
      else
        @faction_affiliation.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:faction][:new_primary_image][:base64], image_file_name: params[:faction][:new_primary_image][:name], title: @faction_affiliation.title, description: @faction_affiliation.title)
      end
    end

    if @faction_affiliation.save
      render json: @faction_affiliation, status: :created
    else
      render json: { message: @faction_affiliation.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PUT api/factions
  def update
    if @faction_affiliation

      if params[:faction][:new_primary_image] != nil
        if @faction_affiliation.primary_image != nil
          @faction_affiliation.primary_image.image = params[:faction][:new_primary_image][:base64]
          @faction_affiliation.primary_image.image_file_name = params[:faction][:new_primary_image][:name]
        else
          @faction_affiliation.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:faction][:new_primary_image][:base64], image_file_name: params[:faction][:new_primary_image][:name], title: @faction_affiliation.title, description: @faction_affiliation.title)
        end
      end

      if @faction_affiliation.update(faction_affiliation_params)
        render json: @faction_affiliation
      else
        render json: { message: @faction_affiliation.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'Faction affiliation not found!' }
    end
  end

  # DELETE api/factions/:id
  def archive
    if @faction_affiliation
      @faction_affiliation.archived = true
      if @faction_affiliation.save
      else
        render status: 500, json: { message: "Faction affiliation could not be archived because: #{@faction_affiliation.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Faction affiliation not found!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faction_affiliation
      @faction_affiliation = FactionAffiliation.find(params[:faction][:id])
      @faction_affiliation ||= FactionAffiliation.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def faction_affiliation_params
      params.require(:faction).permit(:title, :description, :created_by_id)
    end
end
