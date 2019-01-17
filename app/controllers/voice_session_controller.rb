class VoiceSessionController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action only: [:list] do |a|
    a.require_one_role([2])
  end
  # https://medium.com/@jeanpaulsio/an-intro-to-webrtc-for-rails-developers-453c79a0d6a1
  # https://github.com/jeanpaulsio/action-cable-signaling-server/blob/master/app/assets/javascripts/signaling-server.js
  
  def create
    head :no_content
    ActionCable.server.broadcast 'session_channel', session_params
  end

  private
  def session_params
    params.permit(:type, :from, :to, :sdp, :candidate)
  end
end
