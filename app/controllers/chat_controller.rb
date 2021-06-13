class ChatController < ApplicationController
  before_action :require_user
  before_action :require_member

  # GET api/chat
  # GET api/chat/:count
  def list
    @chats = Chat.all.order('created_at desc').take(50).reverse
    render status: 200, json: @chats.as_json(include: { user: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }})
  end

  # POST api/chat
  def create
    @chat = Chat.new(chat_params)
    @chat.user_id = current_user.id
    if @chat.save
      render status: 200, json: { mode: "CREATE", chat: @chat.as_json(include: { user: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }}) }
    else
      render status: 500, json: { message: "Chat could not be created because: #{@chat.errors.full_messages.to_sentence}" }
    end
  end

  # PUT api/chat
  def update
    @chat = Chat.find_by_id params[:chat][:id].to_i
    if @chat
      # security check
      if current_user.id == @chat.user_id || current_user.is_in_one_role([2,3]) # execs, director
        if @chat.update(chat_params)
          render status: 200, json: { mode: "UPDATE", chat: @chat.as_json(include: { user: { only: [:id], methods: [:main_character_full_name, :main_character_avatar_url] }}) }
        else
          render status: 500, json: { message: "Chat could not be updated because: #{@chat.errors.full_messages.to_sentence}" }
        end
      else
        render status: 403, json: { message: 'You are not authorized to use this endpoint.' }
      end
    else
      render status: 404, json: { message: 'Chat message not found or it has been removed.' }
    end
  end

  # DELETE api/chat/:chat_id
  def delete
    @chat = Chat.find_by_id params[:chat_id].to_i
    if @chat
      # security check
      if current_user.id == @chat.user_id || current_user.is_in_one_role([2,3]) # execs, director
        if @chat.destroy
          render status: 200, json: { mode: 'DELETE', chat: { id: params[:chat_id] } }
        else
          render status: 500, json: { message: "Chat could not be updated because: #{@chat.errors.full_messages.to_sentence}" }
        end
      else
        render status: 403, json: { message: 'You are not authorized to use this endpoint.' }
      end
    else
      render status: 404, json: { message: 'Chat message not found or it has been removed.' }
    end
  end

  private
  def chat_params
    params.require(:chat).permit(:text)
  end
end
