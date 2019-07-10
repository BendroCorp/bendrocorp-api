class OauthController < ApplicationController
  before_action :require_user
  before_action :require_member

  # for now will just use the implicit oauth grant

  # state, client_id, response_type, scope, and redirect_uri

  # testing url link
  # http://localhost:4200/oauth?client_id=test-client&response_type=token&state=something&redirect_uri=https://something.com

  # POST api/oauth-client-check
  def client_check
    # show the view test-client

    @client = OauthClient.find_by client_id: params[:request][:client_id]

    @state = params[:state]
    @response_type = params[:request][:response_type]
    @redirect_uri = params[:request][:redirect_uri]
    # @redirect_uri = params[:redirect_uri]
    if @client == nil
      if params[:request][:client_id] != nil
        render status: 400, json: { message: "OAuth client unknown. Cannot process request. #{params[:request][:client_id]}" }
      else
        render status: 400, json: { message: "OAuth client unknown. Cannot process request." }
      end
    else
      render status: 200, json: @client
    end
  end

  # POST api/oauth-token
  # Must provide client_id, response_type, state, redirect_uri
  def oauth_post
    # TODO: Handle others
    # token_type bearer
    # return access_token
    # puts "token created. redirecting..."
    if params[:request][:response_type] == "token"
      # create access_token for this client_id for this user
      # @client_id = OauthClient.find_by client_id: params[:client_id]
      # @scope = params[:scope]
      # @state = params[:state]
      # @token = params[:token]
      # @redirect_uri = params[:redirect_uri]

      @client = OauthClient.find_by client_id: params[:request][:client_id]
      if @client != nil
        db_user = current_user.db_user
        token = OauthToken.new(oauth_client_id: @client.id, user_id: db_user, access_token: make_jwt(db_user, true))
        if token.save
          if params[:request][:redirect_uri] != nil
            link = "#{params[:request][:redirect_uri]}#access_token=#{token.access_token}&state=#{params[:request][:state]}&token_type=bearer"
            # puts "token created. redirecting...."
            # puts link
            # redirect_to link
            render status: 200, json: { message: link }
          else
            render status: 400, json: { message: "Redirect uri not passed. Cannot process request. #{params[:request][:client_id]}" }
          end
        else
          # puts "Token could not be created."
          # raise "Oauth token could not be created."
          # flash[:danger] = "OAuth token could not be created. Cannot process request. #{params[:client_id]}"
          # render 'authorize', :layout => 'login_background'
          render status: 400, json: { message: "OAuth token could not be created. Cannot process request. #{params[:request][:client_id]}" }
        end
      else
        # puts "OAuth client unknown. Cannot process request."
        # flash[:danger] = "OAuth client unknown. Cannot process request."
        # render 'authorize', :layout => 'login_background'
        render status: 400, json: { message: "OAuth client unknown. Cannot process request." }
      end
    else
      # puts "Invalid response type: #{params[:response_type]}"
      # throw "invalid response_type"
      render status: 400, json: { message: "Invalid response type: #{params[:request][:response_type]}. Cannot process request." }
    end
  end

  # DELETE api/oauth-token/:token
  def remove_token
    @token = OauthToken.find_by token: params[:token]
    if @token
      if @token.user == current_user
        if @token.destroy
          render status: 200, json: { message: 'Token removed!' }
        else
          render status: 500, json: { message: "The token could not be removed because: #{@token.errors.full_messages.to_sentence}" }
        end
      else
        render status: 400, json: { message: 'You are not authorized to remove this token.' }
      end
    else
      render status: 404, json: { message: 'Token not found. It may have already been removed.' }
    end
  end
end
