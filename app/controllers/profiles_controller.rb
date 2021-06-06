class ProfilesController < ApplicationController
  before_action :require_user, except: []
  before_action :require_member, except: []

  # GET api/profile
  def list
    render status: 200, json: Character.all.order('first_name').as_json(methods: [:full_name, :current_job, :current_division], include: { jobs: { } })
  end

  # GET api/profile/member
  def list_members
    characters = Character.all.order('first_name')
    characters_out = []
    characters.each { |character| characters_out << character if character.user.is_in_role(0) }

    render status: 200, json: characters_out.as_json(methods: [:full_name, :current_job, :current_division], include: { jobs: { } })
  end

  # GET api/profile/by-division
  def list_by_divsion
    render status: 200, json: Division.all.order('ordinal').as_json(methods: [:division_members])
  end

  # GET api/profile/by-group
  def list_groups
    render status: 200, json: Division.all.order('ordinal').as_json(include: { division_groups: { include: { characters: { include: { gender: {}, species: { }, jobs: { }, application: { }, owned_ships: { include: { ship: { } } } }, methods: [:full_name, :current_job, :current_job_level] } } } })
  end

  # GET api/profile/not-grouped
  def list_not_grouped
    # TODO
  end

  # GET api/profile/:profile_id
  def show
    @character = Character.find_by_id(params[:profile_id])
    if @character
      if current_user.isinrole(7) || @character.application.application_status_id < 6
        # applicant_approval_request.approval.approval_approvers
        if current_user.isinrole(7)
          render status: 200, json: @character.as_json(methods: [:rsi_handle, :full_name, :avatar_url, :avatar_thumbnail_url, :current_job], include: { user: { only: [:id], include: { badges:{ } } }, attendences: { }, awards: { methods: [:image_url] }, jobs: { }, owned_ships: { include: { ship: { } } }, application: { include: { applicant_approval_request: { include: { approval: { include: { approval_approvers: { methods: [:approver_response, :character_name] } } } } }, comments: { methods: [:commenter_name, :avatar_url] }, application_status: { }, job: { }, interview: { } } } })
        else
          render status: 200, json: @character.as_json(methods: [:rsi_handle, :full_name, :avatar_url, :avatar_thumbnail_url, :current_job], include: { user: { only: [:id], include: { badges:{ } } }, attendences: { }, awards: { methods: [:image_url] }, jobs: { }, owned_ships: { include: { ship: { } } }, application: { include: { comments: { methods: [:commenter_name, :avatar_url] }, application_status: { }, job: { }, interview: { } } } })
        end
      else
        render status: 200, json: @character.as_json(methods: [:rsi_handle, :full_name, :avatar_url, :avatar_thumbnail_url, :current_job], include: { user: { only: [:id], include: { badges:{ } } }, attendences: { }, awards: { methods: [:image_url] }, jobs: { }, owned_ships: { include: { ship: { } } } })
      end
    else
      render status: 404, json: { message: 'Profile not found!' }
    end
  end

  # PATCH api/profile/
  def update
    @character = Character.find_by_id(params[:character][:id])
    if @character != nil
      # Security check
      # the character is owned by the current user or the user is in the HR role
      if current_user.id === @character.user_id || current_user.isinrole(7)

        # if the user is not in the HR role
        if !current_user.isinrole(7)
          if @character.update_attributes(character_params)
            render status: 200, json: { message: 'Character updated!' }
          else
            render status: :unprocessable_entity, json: { message: "Character could not be updated because: #{@character.errors.full_messages.to_sentence}" }
          end
        else # if the user is in the HR role
          if @character.update_attributes(character_admin_params)
            render status: 200, json: { message: 'Character updated (with HR rights)!' }
          else
            render status: :unprocessable_entity, json: { message: "Character could not be updated because: #{@character.errors.full_messages.to_sentence}" }
          end
        end
      else
        render status: 403, json: { message: 'You are not authorized to update this character.' }
      end
    else
      render status: 404, json: { message: 'Character not found.' }
    end
  end

  # PATCH|PUT api/profile/handle
  # params[:character][:id|:handle]
  def update_handle
    @character = Character.find_by_id(params[:character][:id].to_i)
    if @character
      # Security check
      # the character is owned by the current user or the user is in the HR role
      if current_user.id == @character.user_id || current_user.isinrole(7) # HR
        page = HTTParty.get("https://robertsspaceindustries.com/citizens/#{params[:character][:handle].downcase}")
        if page.code == 200
          @character.user.rsi_handle = params[:character][:handle]
          if @character.user.save
            render status: 200, json: { message: "Character/user handle updated!" }
          else
            render status: :unprocessable_entity, json: { message: "Character/user handle could not be updated because: #{@character.errors.full_messages.to_sentence}" }
          end
        else
          render status: 400, json: { message: "Handle could not be verified with RSI." }
        end
      else
        render status: 403, json: { message: 'You are not authorized to update this character.' }
      end
    else
      render status: 404, json: { message: 'Character not found.' }
    end
  end

  # PATCH api/profile/avatar
  def update_avatar
    @character = Character.find_by_id(params[:character][:id])
    if @character != nil
      # Security check
      # the character is owned by the current user or the user is in the HR role
      if current_user.id == @character.user_id || current_user.isinrole(7) # HR

        # check for an avatar update
        # if params[:character][:new_avatar]
        #   @character.avatar = params[:character][:new_avatar][:base64]
        #   @character.avatar_file_name = params[:character][:new_avatar][:name]
        # end

        if params[:character][:new_avatar]
          data = params[:character][:new_avatar][:base64].split(',')[1]

          image = MiniMagick::Image.read(StringIO.new(Base64.decode64(data)))
          pipeline = ImageProcessing::MiniMagick.source(image)
          resized_image = pipeline.convert('png').resize_to_fill!(200, 200)

          image_blob = ActiveStorage::Blob.create_after_upload!(
            io: File.open(resized_image.path),
            filename: "#{@character.id}.png",
            content_type: 'image/png'
          )

          @character.avatar.attach(image_blob)

          # queue image sizer jobs as required
          ImageSizerJob.perform_later(@character, 'avatar', { resize: '100x100^', quality: '100%' })
        end

        # save the character back
        if @character.save
          render status: 200, json: { message: 'Character avatar updated!' }
        else
          render status: :unprocessable_entity, json: { message: "Character avatar could not be updated because: #{@character.errors.full_messages.to_sentence}" }
        end
      else
        render status: 403, json: { message: 'You are not authorized to update this character.' }
      end
    else
      render status: 404, json: { message: 'Character not found.' }
    end
  end

  # POST api/profile/ship
  # [:owned_ship] :character_id, :ship_id, :title
  def add_ship
    @owned_ship = OwnedShip.new(owned_ship_params)
    if @owned_ship.valid?
      if current_user.id == @owned_ship.character.user_id || current_user.isinrole(7)
        if @owned_ship.save
          render status: 200, json: @owned_ship
        else
          render status: :unprocessable_entity, json: { message: "Owned ship could not be archived because: #{@owned_ship.errors.full_messages.to_sentence}" }
        end
      else
        render status: 403, json: { message: 'You are not authorized to create this ship!' }
      end
    else
      render status: 400, json: { message: @owned_ship.errors.full_messages.to_sentence }
    end
  end

  # PATCH api/profile/ship
  def update_ship
    # TODO: Updating certain things comes from the ships page
    render status: 500, json: { message: 'Not implemented in API' }
  end

  # DELETE api/profile/ship/:owned_ship_id
  def remove_ship
    @owned_ship = OwnedShip.find_by_id(params[:owned_ship_id].to_i)
    if @owned_ship && !@owned_ship.hidden
      if current_user.id == @owned_ship.character.user_id || current_user.isinrole(7)
        @owned_ship.hidden = true
        if @owned_ship.save
          render status: 200, json: @owned_ship
        else
          render status: :unprocessable_entity, json: { message: "Owned ship could not be archived because: #{@owned_ship.errors.full_messages.to_sentence}" }
        end
      else
        render status: 403, json: { message: "You are not authorized to edit this ship!" }
      end
    else
      render status: 404, json: { message: "Owned ship not found!" }
    end
  end

  # POST api/profile/comment
  # :application_comment
  def add_application_comment
    @application = Application.find_by_id(params[:application_comment][:application_id])
    if @application
      # character app status check
      # Between submitted and executive review
      # puts @application.application_status_id
      if @application.application_status_id > 1 && @application.application_status_id < 4
        @comment = ApplicationComment.new
        @comment.user_id = current_user.id
        @comment.comment = params[:application_comment][:comment]

        @application.comments << @comment

        if @application.save
          render status: 201, json: @comment.as_json(methods: [:commenter_name, :avatar_url])
        else
          render status: :unprocessable_entity, json: { message: "Application comment could not be added because: #{@application.errors.full_messages.to_sentence}" }
        end
      else
        render status: 403, json: { message: 'Application not eligible for application comments.' }
      end
    else
      render status: 404, json: { message: 'Application not found' }
    end
  end

  #
  # def add_application_comment
  #   link = params[:id] #/profiles/firstname-lastname GET
  #   name = link.split('-')
  #
  #   head :unprocessable_entity if name.count != 2 #no spaces allowed
  #
  #   @character = Character.find_by(first_name: name[0].capitalize, last_name: name[1].capitalize) unless name.length != 2
  #   if @character == nil
  #     head 404
  #   else
  #     @comment = ApplicationComment.new
  #     @comment.user_id = current_user.id
  #     @comment.comment = params[:application_comment][:comment]
  #     @character.application.application_comments << @comment
  #     if @character.save
  #       ApplicationCommentChannel.broadcast(@comment)
  #       #ActionCable.server.broadcast \
  #       #  "new_application_comments", #current_user
  #       #  { comment: @comment.comment, user: @comment.user.main_character.first_name, avatar: @comment.user.main_character.avatar(:mini) }
  #
  #       ActionCable.server.broadcast \
  #         "new_application_comments", comment:
  #         CharactersController.render(partial: 'characters/comment', locals: {comment: @comment})
  #
  #       head 200
  #     else
  #       head :unprocessable_entity
  #     end
  #   end
  # end

  private
  def character_params
    params.require(:character).permit(:description, :background)
  end

  private
  def character_admin_params
    params.require(:character).permit(:first_name, :last_name, :nickname, :description, :background)
  end

  private
  def owned_ship_params
    params.require(:owned_ship).permit(:title, :ship_id, :character_id)
  end

  private
  def application_comment_params
    params.require(:application_comment).permit(:character_id, :comment)
  end
end
