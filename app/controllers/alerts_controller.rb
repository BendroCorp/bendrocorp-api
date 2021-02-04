class AlertsController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action only: [:archive, :update, :create] do |a|
    a.require_one_role([2])
  end

  # GET api/alert
  def list
    render status: 200, json: Alert.where("archived = ? AND expires > ?", false, Time.now).as_json(include: { alert_type: {} })
  end

  # POST api/alert
  def create
    @alert = Alert.new(alert_params)
    @alert.user_id = current_user.id
    if @alert.save
      render status: 201, json: @alert.as_json(include: { alert_type: {} })
    else
      render status: 500, json: { message: "Alert could not be created because: #{@alert.errors.full_messages.to_sentence}"}
    end
  end

  # PATCH api/alert/:alert_id
  def update
    if !@alert.nil?
      if @alert.update_attributes(alert_params)
        render status: 200, json: @alert.as_json(include: { alert_type: {} })
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
    params.require(:alert).permit(:title, :description, :expires, :star_object_id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_alert
    # try to find the object
    @alert = SystemMapStarObject.find(params[:alert][:id]) if params[:alert]
    @alert ||= SystemMapStarObject.find(params[:id])

    # return the object as long as its not archived
    @alert unless @alert.archived
  end
end
