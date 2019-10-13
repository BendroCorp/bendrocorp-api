class BotController < ApplicationController
  before_action :require_user
  before_action :require_member

  before_action except: [:bot_check] do |a|
    a.require_one_role([9, 50])
  end

  before_action only: [:bot_check] do |a|
    a.require_one_role([-1])
  end

  def list
    render status: 200, json: Bot.all
  end

  def create
    @bot = Bot.new(bot_params)
    if @bot.save
      @bot.token = make_bot_token @bot.id, @bot.bot_name
      if @bot.save
        render status: 200, json: @bot
      else
        render status: 500, json: { message: "Token could not be added to Bot because: #{@bot.errors.full_messages.to_sentence}" }
      end
    else
      render status: 500, json: { message: "Bot could not be created because: #{@bot.errors.full_messages.to_sentence}" }
    end
  end

  # DELETE /api/bot/:bot_id
  def destroy
    @bot = Bot.find_by_id params[:bot_id]
    if @bot.destroy
      render status: 200, json: { message: 'Bot deleted!' }
    else
      render status: 500, json: { message: "Bot could not be deleted because: #{@bot.errors.full_messages.to_sentence}" }
    end
  end

  # GET /api/bot/check
  def bot_check
    render status: 200, json: { message: 'Hello from bot check!' }
  end

  private
  def make_bot_token bot_id, bot_name
    # get our secret
    secret = (Digest::SHA256.hexdigest Rails.application.secrets.secret_key_base)[0..32]

    use_tfa = false
    use_roles = [-1]

    # form our payload
    payload = {
      sub: bot_id,
      email: 'no-reply@bendrocorp.com',
      roles: use_roles,
      name: bot_name,
      tfa_enabled: use_tfa,
      iat: Time.now.to_i,
      nbf: Time.now.to_i
    }

    token = JWT.encode payload, secret, 'HS256'

    return token
  end

  def bot_params
    params.require(:bot).permit(:bot_name)
  end
end
