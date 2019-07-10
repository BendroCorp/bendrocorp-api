class BadgeController < ApplicationController
  before_action :require_user, except: []
  before_action :require_member, except: []

  before_action except: [] do |a|
    a.require_one_role([2]) #executive
  end

  # GET api/badge
  def list
    render status: 200, json: Badge.where(archived: false)
  end

  # GET api/badge
  def create
    @badge = Badge.new(badge_params)
    @badge.created_by_id = current_user.id
    if @badge.save
      render status: 200, json: @badge
    else
      render status: 500, json: { message: "Badge could not be created because: #{@badge.errors.full_messages.to_sentence}" }
    end

  end

  # PATCH|PUT api/badge
  def update
    @badge = Badge.find_by_id(params[:badge][:id])
    if @badge
      if @badge.update_attributes(badge_params)
        render status: 200, json: @badge
      else
        render status: 500, json: { message: "Badge could not be updated because: #{@badge.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Badge not found!' }
    end
  end

  # DELETE api/badge/:badge_id
  def archive
    @badge = Badge.find_by_id(params[:badge_id])
    if @badge
      @badge.archived = true
      if @badge.save
        render status: 200, json: @badge
      else
        render status: 500, json: { message: "Badge could not be updated because: #{@badge.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Badge not found!' }
    end
  end

  def badge_params
    params.require(:badge).permit(:title, :image_link, :ordinal)
  end
end
