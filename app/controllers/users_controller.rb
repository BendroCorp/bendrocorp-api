require 'httparty'

class UsersController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action only: [:list] do |a|
    a.require_one_role([2])
  end

  # GET api/user
  def list
    render status: 200, json: User.where('id <> 0').as_json(only: [:id, :username, :rsi_handle], include: { discord_identity: { }, roles: { include: { nested_roles: { include: { role_nested: { } } } } } }, methods: [:main_character])
  end

  # GET api/user/me | /userinfo
  def me
    render status: 200, json: current_user.db_user.as_json(only: [:id, :email], include: { discord_identity: { }, roles: { include: { nested_roles: { include: { role_nested: { } } } } } }, methods: [:main_character])
  end

  # GET api/user/approvals
  # GET api/user/approvals/:count
  # GET api/user/approvals/:count/:skip
  def approvals
    approvals_list = []
    if params[:count]
      if params[:skip]
        approvals_list = current_user.db_user.approval_approvers.order('created_at desc').offset(params[:skip].to_i).take(params[:count].to_i)
      else
        approvals_list = current_user.db_user.approval_approvers.order('created_at desc').take(params[:count].to_i)
      end
    else
      approvals_list = current_user.db_user.approval_approvers.order('created_at desc')
    end

    # make sure we are only fetching bound approvals
    approvals_list = approvals_list.to_a.select { |approver| approver.approval.is_bound? }
    # return final approvals_list
    render status: 200, json: approvals_list.as_json(include: { approval_type: { }, approval: { methods: [:approval_status, :approval_link, :approval_source_requested_item, :approval_source, :approval_source_character_name, :approval_source_on_behalf_of], include: { approval_kind: { }, approval_approvers: { methods: [:character_name, :approver_response], include: { approval_type: { } } } } } })
  end

  # GET api/user/approval/:approval_approver_id
  def approval
    @aa = current_user.db_user.approval_approvers.find_by_id(params[:approval_approver_id].to_i)
    if @aa
      render status: 200, json: @aa.as_json(include: { approval_type: { }, approval: { methods: [:approval_status, :approval_link, :approval_source_requested_item, :approval_source, :approval_source_character_name, :approval_source_on_behalf_of], include: { approval_kind: { }, approval_approvers: { methods: [:character_name, :approver_response], include: { approval_type: { } } } } } })
    else
      render status: 404, json: { message: 'No approver record found for that id' }
    end
  end

  # GET api/user/approvals-count-total
  def approvals_count_total
    render status: 200, json: current_user.db_user.approval_approvers.count if current_user.db_user.approval_approvers
  end

  # GET api/user/approvals-count
  def approvals_count
    render status: 200, json: current_user.db_user.approval_approvers.where('approval_type_id < 4').count if current_user.db_user.approval_approvers.where('approval_type_id < 4')
  end

  # GET api/user/oauth-tokens
  def oauth_tokens
    render status: 200, json: OauthToken.where(user_id: current_user.id).as_json(methods: [:client_title])
  end

  # GET api/user/auth-tokens
  def auth_tokens
    render status: 200, json: UserToken.where(user_id: current_user.id).order('created_at desc').as_json(methods: [:is_expired, :perpetual])
  end

  # POST /api/user/end-membership
  def end_membership
    db_user = current_user.db_user
    # is the password correct
    if db_user.authenticate(params[:password])
      # get all of the users roles
      # discord_roles = []
      # db_user.get_all_roles.each do |in_role|
      #   discord_roles << in_role.role.discord_role_id if in_role.role.discord_role_id
      # end

      # # remove from all discord roles
      # EventStreamWorker.perform_async('discord-remove-roles', { roles: discord_roles, identity: discord_identity.as_json }) if db_user.discord_identity

      # remove all the users roles
      db_user.in_roles.destroy_all

      # email the user
      message_body = "<p>Hey #{db_user.main_character.first_name}</p>,<p>This is a confirmation that your membership to BendroCorp has been ended. We are sad to see you go, you may re-join at any time by contacting us via Discord.</p>"
      EmailWorker.perform_async(db_user.email, 'End of Membership Confirmation', message_body)

      # email the executive staff
      Role.where(id: 2).each do |executive|
        message_body = "<p>#{executive.user.main_character.first_name},</p><p>#{db_user.main_character.full_name} has voluntarily terminated thier membership to BendroCorp. They have been removed from the Member role and any roles in Discord.</p>"
        EmailWorker.perform_async(executive.user.email, 'Voluntary Membership Termination', message_body)
      end

      # notify on discord
      EventStreamWorker.perform_async('discord-end-membership', { nickname: discord_identity.user.main_character.full_name, identity: discord_identity.as_json })

      # remove the discord identity
      db_user.discord_identity.destroy if db_user.discord_identity

      render status: 200, json: { message: 'Membership termination complete!' }
    else
      # TODO: Add login increment
      render status: 400, json: { message: 'Incorrect password supplied.' }
    end
  end

  # POST api/user/discord-identity
  def discord_identity

    if params[:code]
      # guild_id = '123161736181317632'
      client_id = '630786822863061014'
      client_secret = ENV["DISCORD_BOT_CLIENT_SECRET"]

      body_string = "client_id=#{client_id}&client_secret=#{client_secret}&grant_type=authorization_code&code=#{params[:code]}&redirect_uri=https%3A%2F%2Fmy.bendrocorp.com%2Fdiscord_callback&scope=guilds.join+email+identify" if ENV["RAILS_ENV"] != nil && ENV["RAILS_ENV"] == 'production'
      body_string ||= "client_id=#{client_id}&client_secret=#{client_secret}&grant_type=authorization_code&code=#{params[:code]}&redirect_uri=http%3A%2F%2Flocalhost%3A4200%2Fdiscord_callback&scope=guilds.join+email+identify"

      response = HTTParty.post('https://discordapp.com/api/v6/oauth2/token', {
        body: body_string,
        headers: {
          'Content-Type' => 'application/x-www-form-urlencoded',
          'charset' => 'utf-8'
        }
      })

      if response.code == 200
        # dump the old one
        if current_user.db_user.discord_identity
          di = current_user.db_user.discord_identity
          di.destroy
        end

        discord_access_token = response['access_token']
        discord_refresh_token = response['refresh_token']

        info_response = HTTParty.get('https://discordapp.com/api/users/@me', {
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{discord_access_token}"
          }
        })

        if info_response.code == 200
          discord_user_id = info_response['id']
          discord_email = info_response['email'] # use this to reference the user account
          discord_username = info_response['username']

          db_user = current_user.db_user
          if discord_email == db_user.email
            discord_identity = DiscordIdentity.new(user_id: current_user.id, discord_username: discord_username, discord_id: discord_user_id, refresh_token: discord_refresh_token)

            if discord_identity.save
              # emit the event
              EventStreamWorker.perform_async('discord-join', { access_token: discord_access_token, nickname: db_user.main_character.full_name, identity: db_user.discord_identity.as_json })

              # render 200
              render status: 200, json: { message: 'Discord identity registered!' }
            else
              render status: 500, json: { message: "Error occured could not save discord identity to user because: #{db_user.errors.full_messages.to_sentence}" }
            end
          else
            render status: 404, json: { message: 'User not found. Your Discord email and account email must match!' }
          end
        else
          render status: 500, json: { message: info_response['error_description'] }
        end
      else
        render status: 500, json: { message: response['error_description'] }
      end
    else
      render status: 400, json: { message: 'Code not provided' }
    end
  end

  # PUT api/user/discord-identity/:discord_identity_id
  def discord_identity_joined
    id = DiscordIdentity.find_by_id(params[:discord_identity_id])
    if id
      id.joined = true
      if id.save
        # emit event
        EventStreamWorker.perform_async('discord-join-complete', { message: "#{id.discord_id} joined to BendroCorp Discord!", discord_identity: id })

        render status: 200, json: { discord_identity: id.as_json, message: "#{id.discord_id} joined to BendroCorp Discord!" }
      else
        render status: 500, json: { message: "Error occured could update discord identity because: #{id.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Discord identity not found!' }
    end
  end

  # POST api/user/push-token
  # Must contain token, user_device_type_id, reg_data (1 = iOS, 2(TODO) = Firebase)
  def add_push_token
    if params[:push_token] && params[:push_token][:token] && params[:push_token][:user_device_type_id] && params[:push_token][:reg_data]
      db_user = current_user.db_user
      device_type = UserDeviceType.find_by_id(params[:push_token][:user_device_type_id].to_i)
      if device_type
        db_user.user_push_tokens << UserPushToken.new(push_params)
        if db_user.save
          render status: 200, json: { message: 'Device token added!' }
        else
          render status: 500, json: { message: "A push token could not be added because: #{db_user.errors.full_messages.to_sentence}" }
        end
      else
        render status: 400, json: { message: 'Device type if not found!' }
      end
    else
      render status: 400, json: { message: 'Incorrect parameters provided or parameters missing.' }
    end
  end

  # GET api/user/push
  def push_self
    send_push_notification current_user.id, "This is a test. You sent this to your devices. :)"
    render status: 200, json: { message: 'Self push succeeded! ;)' }
  end

  # GET api/user/event-test
  def event_self
    EventStreamWorker.perform_async('test', { message: 'This is a test event!' })
    render status: 200, json: { message: 'Test event sent!' }
  end

  private
  def push_params
    params.require(:push_token).permit(:token, :user_device_type_id, :reg_data)
  end

  def discord_identity_params
    params.require(:discord_identity).permit(:discord_id, :discord_snowflake_id)
  end
end
