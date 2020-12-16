class ShipsController < ApplicationController
  before_action :require_user, except: [:list]
  before_action :require_member, except: [:list]

  # GET api/ship
  # Retieves a list of all ships - NOT owned ships
  def list
    render status: 200, json: Ship.all.order(:name)
  end

  # GET api/ship/owned
  def list_owned
    render status: 200, json: OwnedShip.where(hidden: false).as_json(include: { ship: { }, character: { } })
  end

  # GET api/ship/owned/:owned_ship_id
  # Fetch a particular owned ship
  def fetch
    @owned_ship = OwnedShip.find_by_id(params[:owned_ship_id])
    if @owned_ship != nil

      permissions = {}

      in_crew = @owned_ship.user_in_crew(current_user)

      if @owned_ship.character.user_id == current_user.id
        permissions = { isEditor: true }
      else
        permissions = { isEditor: false }
      end
      render :json =>
      {
        :owned_ship => @owned_ship.as_json(include:{ organization_ship_request: { }, crew_members: { include: { character: { methods: [:full_name] }, crew_role: { } } }, crew_roles: {}, flight_logs: { include: { log_owner: {} }, methods: [:log_writer, :log_time_ms, :log_title, :full_location] } }, methods: [:ship_title_with_captain, :all_flight_log_images, :ship_captain, :ship_kind, :fetch_avatar]),
        :permissions => permissions,
        user_in_crew: in_crew
      }
    else
      render status: 404, json: { message: "Ship not found or do you not have permision to view it. Ship ##{params[:owned_ship_id]}" }
    end
  end

  # POST api/ship/owned/
  def create_owned_ship
    @owned_ship = OwnedShip.new(owned_ship_params)
    @owned_ship.character = current_user.main_character

    if @owned_ship.save
      render status: 201, json: @owned_ship
    else
      render status: 500, json: { message: "Owned ship could not be added because: #{@owned_ship.errors.full_messages.to_sentence}" }
    end
  end

  # PATCH api/ship/owned/
  def update_owned_ship
    @owned_ship = OwnedShip.find_by_id(params[:owned_ship][:id])
    if @owned_ship != nil
      if @owned_ship.character_id == current_user.main_character.id
        if @owned_ship.update_attributes(owned_ship_params)
          render status: 201, json: @owned_ship
        else
          render status: 500, json: { message: "Owned ship could not be updated because: #{@owned_ship.errors.full_messages.to_sentence}" }
        end
      else
        render status: 403, json: { message: 'Only the owner of a ship is authorized to edit it!' }
      end
    else
      render status: 404, json: { message: "Ship not found or do you not have permision to view it. Ship ##{params[:owned_ship_id]}" }
    end
  end

  # DELETE api/ship/owned/:owned_ship_id
  def delete_owned_ship
    @owned_ship = OwnedShip.find_by id: params[:owned_ship_id]
    if @owned_ship != nil
      if (@owned_ship.character.user.id == current_user.id) || current_user.is_in_one_role([2])
        @owned_ship.hidden = true # we soft delete owned ships as they can be tied to many things - ships are kind of central to Star Citizen
        if @owned_ship.save
          render status: 200, json: { message: 'Owned ship removed!' }
        else
          render status: 500, json: { message: "Owned ship could not be added because: #{@owned_ship.errors.full_messages.to_sentence}" }
        end
      else
        render status: 403, json: { message: 'Only the owner of a ship is authorized to edit it!' }
      end
    else
      render status: 404, json: { message: "Ship not found or do you not have permision to view it. Ship ##{params[:owned_ship_id]}" }
    end
  end

  # POST api/ship/owned/:owned_ship_id/avatar
  # params[:image]
  def change_avatar
    @owned_ship = OwnedShip.find_by_id(params[:owned_ship_id].to_i)
    if @owned_ship != nil
      if @owned_ship.character.id == current_user.main_character.id
        @owned_ship.avatar.image = "data:#{params[:image][:filetype]};base64,#{params[:image][:base64]}"
        @owned_ship.avatar.image_file_name = params[:image][:filename]
        if @owned_ship.save
          render status: 200, json: { message: "Ship avatar updated." }
        else
          render status: 500, json: { message: "Error Occured: Ship avatar could not be updated." }
        end
      else
        render status: 403, json: { message: "You do not have the permissions required to alter attributes of this ship." }
      end
    else
      render status: 404, json: { message: "Owned ship not found" }
    end
  end

  # filling positions always comes from a ship crew request - which has a unique handler
  # POST api/ship/owned/:owned_ship_id/crew
  def crew_position_create
    @owned_ship = OwnedShip.find_by_id(params[:owned_ship_id].to_i)
    if @owned_ship != nil
      if @owned_ship.character.id == current_user.main_character.id
        #OwnedShipCrewRole
        @new_role = OwnedShipCrewRole.new(crew_role_params)
        @new_role.ordinal = 3
        @new_role.owned_ship_id = @owned_ship.id
        if @new_role.save
          render status: 201, json: { message: "New crew role created.", role: @new_role }
        else
          render status: 500, json: { message:"Error Occured: Role could not be created." }
        end
      else
        render status: 403, json: { message: "You do not have the permissions required to alter attributes of this ship." }
      end
    else
      render status: 404, json: { message: "Owned ship not found" }
    end
  end

  # PATCH api/ship/:owned_ship_id/crew
  def crew_position_update
    @owned_ship = OwnedShip.find_by_id(params[:owned_ship_id].to_i)
    if @owned_ship != nil
      if @owned_ship.character.id == current_user.main_character.id
        # look up role
        @crew_role = OwnedShipCrewRole.find_by_id(params[:crew_role][:id].to_i)
        if @crew_role != nil
          if @crew_role.editable == true
            if @crew_role.update_attributes(crew_role_params)
              render status: 200, json: { message: "Crew role updated." }
            else
              render status: 500, json: { message: "Error Occured: Crew role could not be updated." }
            end
          else
            render status: 403, json: { message: "This crew position can not be edited." }
          end
        else
          render status: 404, json: { message: "Crew role not found" }
        end
      else
        render status: 403, json: { message: "You do not have the permissions required to alter attributes of this ship." }
      end
    else
      render status: 404, json: { message: "Owned ship not found" }
    end
  end


  # DELETE api/ship/owned/:owned_ship_id/crew/:crew_position_id
  def crew_position_delete
    @owned_ship = OwnedShip.find_by_id(params[:owned_ship_id].to_i)
    if @owned_ship != nil
      if @owned_ship.character.id == current_user.main_character.id # make sure the current_user is the ships commander
        # look up role
        @crew_role = OwnedShipCrewRole.find_by_id(params[:crew_position_id].to_i)
        if @crew_role != nil
          if @crew_role.editable == true
            if @crew_role.destroy
              render status: 200, json: { message: "Crew role deleted." }
            else
              render status: 500, json: { message: "Error Occured: Crew role could not be deleted." }
            end
          else
            render status: 403, json: { message: "This crew position can not be edited." }
          end
        else
          render status: 404, json: { message: "Crew role not found" }
        end
      else
        render status: 403, json: { message: "You do not have the permissions required to alter attributes of this ship." }
      end
    else
      render status: 404, json: { message: "Owned ship not found" }
    end
  end

  # DELETE api/ship/owned/:owned_ship_id/crew-member/:crew_member_id
  def remove_from_crew_position
    # OwnedShipCrew
    # OwnedShipCrewRequest
    @owned_ship = OwnedShip.find_by_id(params[:owned_ship_id].to_i)
    if @owned_ship != nil
      if @owned_ship.character.id == current_user.main_character.id
        crew_member = OwnedShipCrew.find_by_id(params[:crew_member_id])
        if crew_member.character.user.id != current_user.id
          if crew_member != nil
            if crew_member.destroy
              render status: 200, json: { message: "Crew member deleted." }
            else
              render status: 500, json: { message: "Error Occured: Crew member could not be deleted." }
            end
          else
            render status: 404, json: { message: "Crew member not found" }
          end
        else
          render status: 403, json: { message: "You cannot remove yourself from your own crew role." }
        end
      else
        render status: 403, json: { message: "You do not have the permissions required to alter attributes of this ship." }
      end
    else
      render status: 404, json: { message: "Owned ship not found" }
    end
  end

  def owned_ship_params
    params.require(:owned_ship).permit(:title, :ship_id)
  end

  def crew_role_params
    params.require(:crew_role).permit(:title, :description, :role_slots, :recruitable)
  end
end
