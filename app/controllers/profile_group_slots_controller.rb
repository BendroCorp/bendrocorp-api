class ProfileGroupSlotsController < ApplicationController
  before_action :set_profile_group_slot, only: [:show, :update, :destroy]

  # GET /profile_group_slots
  def index
    @profile_group_slots = ProfileGroupSlot.all

    render json: @profile_group_slots
  end

  # GET /profile_group_slots/1
  def show
    render json: @profile_group_slot
  end

  # POST /profile_group_slots
  def create
    @profile_group_slot = ProfileGroupSlot.new(profile_group_slot_params)

    if @profile_group_slot.save
      render json: @profile_group_slot, status: :created, location: @profile_group_slot
    else
      render json: @profile_group_slot.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profile_group_slots/1
  def update
    if @profile_group_slot.update(profile_group_slot_params)
      render json: @profile_group_slot
    else
      render json: @profile_group_slot.errors, status: :unprocessable_entity
    end
  end

  # DELETE /profile_group_slots/1
  def destroy
    @profile_group_slot.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_group_slot
      @profile_group_slot = ProfileGroupSlot.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profile_group_slot_params
      params.require(:profile_group_slot).permit(:profile_group_id, :character_id, :role_id, :title, :ordinal, :exempt)
    end
end
