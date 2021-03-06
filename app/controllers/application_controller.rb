include SendGrid # required to access the helper methods
class ApplicationController < ActionController::API
  # Capture and handle any errors
  include Error::ErrorHandler
  before_action :set_paper_trail_whodunnit
  # before_action :add_allow_credentials_headers

  # # Handle CORS requests
  # def add_allow_credentials_headers
  # 	# https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS#section_5
  # 	#
  # 	# Because we want our front-end to send cookies to allow the API to be authenticated
  # 	# (using 'withCredentials' in the XMLHttpRequest), we need to add some headers so
  # 	# the browser will not reject the response
  # 	# https://stackoverflow.com/questions/17858178/allow-anything-through-cors-policy

  # 	# TODO: Need to add an allowed origins table - not totally sure on this still
  # 	response.headers['Access-Control-Allow-Origin'] = '*' # this eventually needs to be restricted
  # 	response.headers['Access-Control-Allow-Methods'] = 'POST, PATCH, PUT, DELETE, GET, OPTIONS'
  # 	response.headers['Access-Control-Request-Method'] = '*'
  # 	response.headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization, HTTP_AUTHORIZATION, HTTP_X_AUTHORIZATION'
  # end

	# # https://stackoverflow.com/questions/32500073/request-header-field-access-control-allow-headers-is-not-allowed-by-itself-in-pr
  # def options
	#    render :status => 200, :'Access-Control-Allow-Headers' => 'accept, content-type, authorization, HTTP_AUTHORIZATION, HTTP_X_AUTHORIZATION'
  # end

  def true?(obj)
    obj.to_s == "true"
  end

  def make_token(length = 100)
    # o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    # Digest::SHA256.hexdigest(0...length).map { o[rand(o.length)] }.join
    o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
    string = (0...length).map { o[rand(o.length)] }.join
    Digest::SHA256.hexdigest(string)
  end

  # Create a JWT token set
  # @param [User] The ActiveRecord user object
  # @param [Bool] offline_access Optional: Create a refresh_token and short the JWT expiration
  # @param [Bool] create_refresh Optional Override: Set to false to skip creating a fresh token when offline_access is supplied
  # @return { id_token, refresh_token }
  def make_jwt user, offline_access = false, create_refresh = true
    # secret guard
    throw 'Secret could not be retrieved for tokenization!' if Rails.application.credentials[Rails.env.to_sym][:secret_key_base] == nil || Rails.application.credentials[Rails.env.to_sym][:secret_key_base].length < 10 # secret will be longer than this

    # get our secret
    secret = (Digest::SHA256.hexdigest Rails.application.credentials[Rails.env.to_sym][:secret_key_base])[0..32]

    # form our payload
    payload = {
      sub: user.id,
      email: user.email,
      roles: user.get_all_roles.map { |r| r[:id] },
      name: user.username,
      tfa_enabled: user.use_two_factor,
      subscriber: user.is_subscriber,
      iat: Time.now.to_i,
      nbf: Time.now.to_i
    }

    # if the user has a character include that information
    unless user.main_character.nil?
      payload[:character_id] = user.main_character.id
      payload[:given_name] = user.main_character.first_name
      payload[:family_name] = user.main_character.last_name
      payload[:avatar] = user.main_character.avatar_url
      payload[:job_title] = user.main_character.current_job_title
    end

    # set the expiration
    # NOTE: Expiration is currently set for six hours down from 12 hours since we are adding in refresh tokens
    payload[:exp] = (Time.now.to_i + (6 * 3600)).to_i if !offline_access
    #
    payload[:exp] = (Time.now.to_i + (1 * 3600)).to_i if offline_access

    token = JWT.encode payload, secret, 'HS256'

    return { access_token: token, id_token: token } if !offline_access || (offline_access && !create_refresh)
    return { access_token: token, id_token: token, refresh_token: make_token(75) } if offline_access && create_refresh
  end

  def current_user
    if bearer_token
      # get our secret
      secret = (Digest::SHA256.hexdigest Rails.application.credentials[Rails.env.to_sym][:secret_key_base])[0..32]
      begin
        # decode
        decoded_token = JWT.decode bearer_token, secret, true, { algorithm: 'HS256' }
        # make a token user
        user = TokenUser.new(decoded_token[0])
        # return payload
        # puts 'da user:'
        # puts user
        user
      rescue JWT::ExpiredSignature
        # We will do nothing. A null return will trigger a 401 wherever current_user is required
      end
    end
  end

  # checks to make sure that a user is "logged in"
  def require_user
    render status: 401, json: { message: 'You are not logged in/authorization required/you are not authorized to use this application.' }  unless current_user != nil && !current_user.db_user.nil?
  end

  # make sure that the current user in the member role
  def require_member
    in_role = current_user.isinrole(0)
    render status: 403, json: { message: 'You are not authorized to use this endpoint.' } unless in_role #current_user.is_member?
  end

  # before_action
  # do not use this without first using require_user
  def require_role(role_id)
    if !(current_user && current_user.isinrole(role_id))
      # Email if this is a logged in user trying to access part of the api they shouldn't be in
      if ENV["RAILS_ENV"] != nil && ENV["RAILS_ENV"] == 'production' && current_user
        vMessage = "#{current_user.id} tried to access an endpoint which they do not have access to: #{request.original_url}. Please take appropriate action."
        send_email('dale@daleslab.com', 'Unauthorized Endpoint Use', vMessage)
      end

      # TODO: Always a log access violations

      # return to the user
      render status: 403, json: { message: 'You are not authorized to use this endpoint.' }
    end
  end

  def require_one_role(role_id_array)
    isInRole = false
    role_id_array.each do |role_id|
      isInRole = true if (current_user && current_user.isinrole(role_id))
    end

    if !isInRole
      render status: 403, json: { message: 'You are not authorized to use this endpoint.' }
    end
  end

  def create_activity
    # TODO:
  end

  def new_approval (approval_kind_id, owner_id = 0, approval_group = 0, approval_id_list = [], approvals_required = true)
    @approval_kind = ApprovalKind.find(approval_kind_id.to_i)
    if @approval_kind != nil
      new_approval = Approval.new(approval_kind_id: @approval_kind.id) #approval kind id
      new_approval.full_consent = @approval_kind.workflow_id != 4

      users_array = Array.new
      approval_kind_roles = @approval_kind.roles
      if approval_kind_roles.count > 0
        approval_kind_roles.each do |role|
          User.where("is_member = ?", true).each do |user|
            users_array << user if user.isinrole(role.id)
          end
        end
      else
        # if we can't find roles then we need to get the owner object
        # somehow we need to get the ship owner user here when that object is no available yet
        # some kinds of requests might not have roles - it might be an object with an owner who gets to manage what happens

        # submit to a specific user
        if owner_id != 0 && approval_group == 0 && approval_id_list.count == 0
          owner = User.find_by_id(owner_id.to_i)
          if !owner.nil?
            users_array << owner
          else
            raise 'Cannot create the approval request. The selected approval kind has no roles assigned to it and no valid owner user id was supplied.'
          end
        # submit to a specific approval group
        elsif owner_id == 0 && approval_group != 0 && approval_id_list.count == 0
          role = Role.find_by_id(approval_group.to_i)
          if !role.nil?
            User.where("is_member = ?", true).each do |user|
              users_array << user if user.isinrole(role.id)
            end
          else
            raise 'Cannot not create approval request. The selected approval kind has no assigned roles and the provided group value could not be found.'
          end

        # submit to a specific list of approvers
        elsif owner_id == 0 && approval_group == 0 && approval_id_list.count != 0
          users_array.concat User.where('id IN (?) AND is_member = ?', approval_id_list, true)
        else
          raise 'Cannot create the approval request. The selected approval kind has no roles assigned to it.'
        end
      end

      users_array.uniq! { |x| x } # get uniq users

      if users_array.count > 0
        # add all of the approvers to the approval and email them
        users_array.each do |user|
          new_approval.approval_approvers << ApprovalApprover.new(user_id: user.id, approval_type_id: 1, required: approvals_required)
        end

        new_approval.save #save approval so we can get the id since this is disconnected somewhat

        #return the object id
        new_approval.id
      else
        raise 'Cannot create the approval request. The provided request type has no roles with users.'
        #cannot create approval...there has to be approvers
      end
    else
      raise 'approval_kind_id not passed to make_approval!'
    end
  end

  # remove an existing approval. This is usually done if some kind of error occurs in the process
  def cancel_approval(approval_id)
    @approval = Approval.find_by_id(approval_id)
    if @approval
      # Email all of the approvers
      @approval.approval_approvers do |approver|
        send_email(approver.user.email, "Approval Cancelled", "<p>Hello #{user.username}!</p><p>A recent approval that was created for you was cancelled and removed. This is likely because there was an error creating the final request.</p>")
      end

      # Get rid of it
      @approval.destroy
    end
  end

  def email_members(subject, message)
    users = User.all
    users.each do |user|
      send_email(user.email, subject, message) if user.isinrole(0)
    end
  end

  # eventually this goes into a background process
  def email_groups(role_id_array, subject, message)
    emails_array = Array.new
    role_id_array.each do |role_id|
      role = Role.find_by id: role_id
      if role != nil
        # role.users.where("is_member = ?", true).each do |user|
        User.all.each do |user|
          emails_array << user.email if user.isinrole(role_id) && user.isinrole(0)
          #
        end # loop to get user emails
      end # check to make sure role exists
    end # group loop

    # Remove any duplicates
    unique_emails = emails_array.uniq { |x| x }

    # actually send the email(s)
    unique_emails.each do |emaily|
      send_email(emaily, subject, message)
    end
  end

  def send_email(to_in, subject_in, message_in)
    puts
    puts message_in if ENV['SENDGRID_API_KEY'] == nil
    puts
    EmailWorker.perform_async to_in, subject_in, message_in
  end

  # Triggers push worker to a send a notifcation to all members
  def send_push_notification_to_members(message, data: nil, apns_category: nil)
    User.all.each do |user|
      PushWorker.perform_async(user.id, message, data: data, apns_category: apns_category) if user.isinrole(0)
    end
  end

  # Send a push notification to everyone in the selected groups
  def send_push_notification_to_groups(role_id_array, message, data: nil, apns_category: nil)
    user_id_array = []
    role_id_array.each do |role_id|
      role = Role.find_by id: role_id
      if role != nil
        # role.users.where("is_member = ?", true).each do |user|
        User.all.each do |user|
          user_id_array << user.id if user.isinrole(role_id) && user.isinrole(0)
          #
        end # loop to get user emails
      end # check to make sure role exists
    end # group loop

    # uniq them
    unique_user_ids.uniq!

    # actually send the notifications
    unique_user_ids.each do |user_id|
      PushWorker.perform_async(user_id, message, apns_category, data)
    end
  end

  # Send a push notification to single user
  def send_push_notification(user_id, message, data: nil, apns_category: nil)
    # send the push
    PushWorker.perform_async(user_id, message, apns_category, data)
  end

  # Create a key in redis
  def create_redis_key(*params)
    redis = Redis.new

    raise 'You must supply a key: to set_redis_key' unless params.has_key?(:key)
    raise 'You must supply a value: to set_redis_key' unless params.has_key?(:value)

    key = params[:key]
    value = params[:value]
    ttl = params[:ttl] if params.has_key?(:ttl)

    redis.set(key, value)

    redis.expire(key, ttl) unless ttl.nil?
  end

  # Fetch a key from redis
  def fetch_redis_key(*params)
    raise 'You must supply a key: to clear_redis_key' unless params.has_key?(:key)
    redis = Redis.new

    key = params[:key]

    redis.get key
  end

  # Set TTL the specified redis key
  def ttl_redis_key(*params)
    raise 'You must supply a key: to expire_redis_key' unless params.has_key?(:key)
    raise 'You must supply a ttl: to expire_redis_key' unless params.has_key?(:ttl)

    key = params[:key]
    ttl = params[:ttl]

    redis.expire(key, ttl)
  end

  # Clear the specified redis key
  def clear_redis_key(*params)
    raise 'You must supply a key: to clear_redis_key' unless params.has_key?(:key)
    redis = Redis.new

    key = params[:key]

    redis.del key
  end

  private
  def bearer_token
    # try to get it from the body
    pattern = /^(Bearer|Basic|bearer|basic) / #
    header = request.env["HTTP_AUTHORIZATION"] #
    header ||= request.env["HTTP_X_AUTHORIZATION"] #

    # we also allow the token to be passed in the URI
    uri_token = request.query_parameters["access_token"]
    uri_token ||= request.request_parameters["access_token"]

    # prep the final header
    header = header.gsub(pattern, '') if header && header.match(pattern)
    header ||= uri_token if uri_token
    return header
  end
end
