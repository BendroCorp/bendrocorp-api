class ProfileGroupMembersController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action except: [:index, :show] do |a|
    a.require_one_role([2])
  end

  before_action :set_profile_group_member, only: [:show, :update, :destroy]

  # # GET /profile_group_members
  # def index
  #   @profile_group_members = ProfileGroupMember.all

  #   render json: @profile_group_members
  # end

  # # GET /profile_group_members/1
  # def show
  #   render json: @profile_group_member
  # end

  # POST /profile_group_members
  def create
    @profile_group_member = ProfileGroupMember.new(profile_group_member_params)

    if @profile_group_member.save
      render json: @profile_group_member, status: :created
    else
      render json: @profile_group_member.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profile_group_members/1
  def update
    if @profile_group_member.update(profile_group_member_params)
      render json: @profile_group_member
    else
      render json: @profile_group_member.errors, status: :unprocessable_entity
    end
  end

  # DELETE /profile_group_members/1
  def destroy
    @profile_group_member.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile_group_member
      @profile_group_member = ProfileGroupMember.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def profile_group_member_params
      params.require(:profile_group_member).permit(:member_title, :character_id, :profile_group_id, :ordinal)
    end
end
