class AlertsController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action only: [:archive, :update, :create] do |a|
    a.require_one_role([2])
  end

  before_action :set_alert, only: [:show, :update, :archive]

  # GET api/alert
  def list
    render status: 200, json: Alert.where("archived = ? AND approved = ? AND (expires > ? OR expires IS NULL)", false, true, Time.now).order('created_at desc').as_json(include: { star_object: { methods: [:kind, :title_with_kind, :primary_image_url] }, alert_type: {}, user: { only:[:id], methods: [:main_character] } })
  end

  # GET api/alert/:id
  def show
    if !@alert.nil?
      render status: 200, json: @alert.as_json(include: { star_object: { methods: [:kind, :title_with_kind, :primary_image_url] }, alert_type: {}, user: { only:[:id], methods: [:main_character] } })
    else
      render status: 404, json: { message: 'Alert not found.' }
    end
  end

  # POST api/alert
  def create
    @alert = Alert.new(alert_params)
    @alert.user_id = current_user.id
    @alert.approved = true # if its made this way its automatically approved
    @alert.expires = Time.at(params[:alert][:expires_ms] / 1000.0) if params[:alert][:expires_ms]
    if @alert.save
      render status: 201, json: @alert.as_json(include: { star_object: { methods: [:kind, :title_with_kind, :primary_image_url] }, alert_type: {}, user: { only:[:id], methods: [:main_character] } })
    else
      render status: 500, json: { message: "Alert could not be created because: #{@alert.errors.full_messages.to_sentence}"}
    end
  end

  # PUT api/alert/:alert_id
  def update
    if !@alert.nil?
      @alert.expires = Time.at(params[:alert][:expires_ms] / 1000.0) if params[:alert][:expires_ms]
      if @alert.update(alert_params)
        render status: 200, json: @alert.as_json(include: { star_object: { methods: [:kind, :title_with_kind, :primary_image_url] }, alert_type: {}, user: { only:[:id], methods: [:main_character] } })
      else
        render status: 500, json: { message: "Alert could not be created because: #{@alert.errors.full_messages.to_sentence}"}
      end
    else
      render status: 404, json: { message: 'Alert not found.' }
    end
  end

  # DELETE api/alert/:alert_id
  def archive
    if !@alert.nil?
      @alert.archived = true
      if @alert.save
        render status: 200, json: { message: 'Alert archived.' }
      else
        render status: 500, json: { message: "Alert could not be created because: #{@alert.errors.full_messages.to_sentence}"}
      end
    else
      render status: 404, json: { message: 'Alert not found.' }
    end
  end

  private
  def alert_params
    params.require(:alert).permit(:title, :description, :star_object_id, :alert_type_id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_alert
    # try to find the object
    @alert = Alert.find_by_id(params[:alert][:id]) if params[:alert]
    @alert ||= Alert.find_by_id(params[:id])

    # return the object as long as its not archived
    @alert unless @alert.archived
  end
end
