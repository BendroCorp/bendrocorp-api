class SiteRequestsController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action only: [:add_role, :add_role_post, :add_award, :add_award_post, :add_award_fetch_toon_awards, ] do |a|
    a.require_one_role([2])
  end
  before_action only: [:remove_role, :remove_role_post, :remove_role_fetch_user_roles] do |a|
    a.require_one_role([2])
  end
  before_action only: [:position_change, :position_change_post] do |a|
    a.require_one_role([2, 3])
  end

  #get 'requests/add_role'
  def add_role
    # NOTE: DEPRECATED, use api/users, api/role
    # @user = current_user
    # if current_user.get_all_roles.count > 0
    #   excluded_roles =[]
    #   current_user.get_all_roles.each do |existing_role|
    #     # excluded_roles << existing_role[:id]
    #   end
    #   @roles = Role.all.order("name") #where("id NOT IN (?)", excluded_roles)
    # else
    #   @roles = Role.all.order("name")
    # end
    # @characters = Character.all
  end

  # POST api/requests/add-role
  # Body needs to contain role_request object
  def add_role_post
    # is the user already in the role_id
    @userNewRole = Character.find_by_id(params[:role_request][:on_behalf_of_id].to_i)
    if @userNewRole != nil
      if !@userNewRole.user.isinrole(params[:role_request][:role_id])
        rr = RoleRequest.new(user_id: current_user.id, role_id: params[:role_request][:role_id].to_i, on_behalf_of_id: @userNewRole.id)

        # put the approval instance in the request
        rr.approval_id = new_approval(1) #request and retrive the new approval object id

        # lastly add the request to the current_user
        rr.user_id = current_user.id

        # save the current_user
        if rr.save
          render status: 201, json: { message: 'Role requested created.' }
        else
          cancel_approval(rr.approval_id)
          render status: 500, json: { message: "Role request could not be saved because: #{rr.errors.full_messages.to_sentence}" }
        end
      else
        render status: 400, json: { message: 'The selected user is already in the requested role.' }
      end
    else
      render status: 400, json: { message: 'User not found. Request could not be made.' }
    end
  end

  # #get 'requests/remove_role'
  # NOTE Both are DEPRECATED:
  # Please use api/user/:user_id to fetch a user and their roles
  # def remove_role
  #   @characters = Character.all
  # end
  #
  # #get 'requests/remove_role/fetch_roles/:user_id'
  # def remove_role_fetch_user_roles
  #   user = User.find_by_id(params[:user_id])
  #   if user != nil
  #     render html: SiteRequestsController.render(partial: 'site_requests/current_roles', locals: {user: user}) #:json => user.roles.to_json(:include => :nested_roles)
  #   end
  # end

  # post api/requests/remove-role
  # role_removal_request[:role_id|:on_behalf_of_id]
  def remove_role_post
    #is the user already in the role_id
    @userNewRole = User.find_by_id(params[:role_removal_request][:on_behalf_of_id].to_i)
    if @userNewRole != nil
      if @userNewRole.isinrole(params[:role_removal_request][:role_id])
        rr = RoleRemovalRequest.new(user_id: current_user.id, role_id: params[:role_removal_request][:role_id].to_i, on_behalf_of_id: params[:role_removal_request][:on_behalf_of_id].to_i)

        # put the approval instance in the request
        rr.approval_id = new_approval(12) #request and retrive the new approval object id

        # lastly add the request to the current_user
        rr.user_id = current_user.id

        # save the current_user
        if rr.save
          render status: 201, json: { message: 'Role removal requested created.' }
        else
          cancel_approval(rr.approval_id)
          render status: 500, json: { message: "Role removal request could not be saved because: #{rr.errors.full_messages.to_sentence}" }
        end
      else
        render status: 400, json: { message: 'The selected user is not in the requested role and thus cannot be removed from it.' }
      end
    else
      render status: 404, json: { message: 'User not found. Request could not be made.' }
    end
  end

  #get 'requests/award-request/fetch_awards/:char_id'
  def add_award_fetch_toon_awards
    # NOTE: DEPRECATED, use api/award to list possible awards
    # toon = Character.find_by_id(params[:char_id])
    # if toon.awards.count > 0
    #   excluded_awards =[]
    #   toon.awards.where("multiple_awards_allowed = ? OR outofband_awards_allowed = ? ", false, false).each do |existing_award|
    #     excluded_awards << existing_award[:id] #unless existing_award.multiple_awards_allowed #&& existing_award.outofband_awards_allowed
    #   end
    #   # if the toon has awards get the ones they are eligible for
    #   # that are also awardable outside of operations
    #   awards = Award.where("id NOT IN (?) and outofband_awards_allowed = ?", excluded_awards, true).order("name")
    # else
    #   #if the toon has no awards then show all of them
    #   awards = Award.where("outofband_awards_allowed = ?", true).order("name")
    # end
    # if awards != nil
    #   render html: SiteRequestsController.render(partial: 'site_requests/current_awards', locals: {awards: awards}) #:json => user.roles.to_json(:include => :nested_roles)
    # end
  end

  # POST api/requests/award-request
  # add_award_request[:award_id|:on_behalf_of_id]
  def add_award_post
    #get all the toons in case we need them
    @characters = Character.all
    #is the user already in the role_id
    @character = Character.find_by_id(params[:add_award_request][:on_behalf_of_id].to_i)
    if @character != nil
      award = @character.awards.find_by_id(params[:add_award_request][:award_id])
      if award != nil && (award.multiple_awards_allowed && award.outofband_awards_allowed)
        ar = AwardRequest.new(user_id: current_user.id, award_id: params[:add_award_request][:award_id].to_i, on_behalf_of_id: params[:add_award_request][:on_behalf_of_id].to_i)

        # put the approval instance in the request
        ar.approval_id = new_approval(3) #request and retrive the new approval object id

        # lastly add the request to the current_user
        ar.user_id = current_user.id

        # save the current_user
        if ar.save
          flash[:success] = 'Add award request successfully submitted.'
          redirect_to :action => 'add_award'
        else
          flash[:danger] = 'Error: Add award request could not be saved.'
          render 'add_award'
        end
      else
        flash[:info] = 'The selected character has already been awarded the indicated award, that award can not be awarded out of band from an event or the selected award was not found.'
        render 'add_award'
      end
    else
      flash[:warning] = "Character or award not found. Request could not be made."
      redirect_to '/'
    end
  end

  def position_change_fetch
    # NOTE: DEPRECATED
    # Use api/jobs
    # Use api/profiles
    # @jobs = Job.all.order('title asc')
    # @characters = []
    # toons = Character.all.order('first_name asc')
    #
    # toons.each do |toon|
    #   @characters << toon if toon.user.is_member? && toon != current_user.main_character
    # end
    #
    # @requests = PositionChangeRequest.where('user_id = ?', current_user.id)
    #
    # render status: 200, json: { characters: @characters.as_json(methods: [:full_name]), jobs: @jobs, requests: @requests.as_json(include: { approval: { methods: [:approval_status]}, job: {}, character: { methods: [:full_name]} }) }
  end

  # POST api/requests/position-change
  def position_change_post
    # check to make sure that the job is available
    job = Job.find_by_id(params[:position_change_request][:job_id].to_i)
    if job
      if !job.max_hired
        # Create the position change request
        positionChangeRequest = PositionChangeRequest.new(position_change_params)

        # put the approval instance in the request
        positionChangeRequest.approval_id = new_approval(22) # position change approval

        # lastly add the request to the current_user
        positionChangeRequest.user_id = current_user.id

        if positionChangeRequest.save
          render status: 200, json: { message: 'Requested submitted!' }
        else
          cancel_approval(positionChangeRequest.approval_id)
          render status: 500, json: { message: "Error occured. Could not complete request because: #{positionChangeRequest.errors.full_messages.to_sentence}" }
        end
      else
        render status: 400, json: { message: 'Cannot create a position change for this job. All positions are filled.' }
      end
    else
      render status: 404, json: { message: 'Cannot create a position change for this job - it either does not exist or has been removed!' }
    end
  end

  def add_organization_ship
    # NOTE: DEPRECATED - use api/division
    # we have the current_user object which should be able to get all of the releveant data
    # to build the form
    # @divisions = Division.where("can_have_ships = ?", true)
    # @org_ship_request = OrganizationShipRequest.new
  end

  # POST api/requests/organization-ship
  def add_organization_ship_post
    #t.belongs_to :user #required field/fk
    #t.belongs_to :owned_ship
    #t.belongs_to :approval #required field/fk
    #t.belongs_to :division

    @owned_ship = current_user.main_character.owned_ships.find_by_id(params[:org_ship_request][:owned_ship_id].to_i)
    if @owned_ship != nil
      if !@owned_ship.is_corp_ship
        cshipr = OrganizationShipRequest.new(user_id: current_user.id, owned_ship_id: params[:owned_ship_id].to_i, division_id: params[:division_id].to_i, procedures_document_web_link: params[:procedures_document_web_link])

        newApproval = new_approval(11)
        cshipr.approval_id = newApproval
        cshipr.owned_ship_id = @owned_ship.id
        if cshipr.save
          @owned_ship.organization_ship_request_id = cshipr.id
          if @owned_ship.save
            render status: 200, json: @owned_ship
          else
            render status: 500, json: { message: "The organization ship requests was created but could not be added to your ship because: #{@owned_ship.errors.full_messages.to_sentence}" }
          end
        else
          # flash[:danger] = 'ERROR: Organization Ship request could not be created. Please try again later.'
          # redirect_to :action => 'add_organization_ship'
          render status: 500, json: { message: "Organization ship request could not be saved because: #{cshipr.errors.full_messages.to_sentence}" }
        end
      else
        # flash[:warning] = 'This ship is already registered as an organization ship.'
        # redirect_to :action => 'add_organization_ship'
        render status: 400, json: { message: "This ship is already registered as an organization ship." }
      end
    else
      # flash[:danger] = 'Either the ship was not found or it is not a ship you own.'
      # redirect_to :action => 'add_organization_ship'
      render status: 400, json: { message: "Either the ship was not found or it is not a ship you own." }
    end
  end

  # GET api/requests/crew
  # # TODO: move this somewhere more consistent
  def ship_crew_request
    # treat this like a job board...just get the open roles
    @crew_roles = []
    croles = OwnedShipCrewRole.all
    croles.each do |role|
      @crew_roles << role if role.role_slots > role.crew_members.count && role.recruitable == true
    end

    render status: 200, json: @crew_roles
  end

  # POST api/requests/crew
  def ship_crew_request_post
    # params needed crew_role_id
    crew_role = OwnedShipCrewRole.find_by_id(params[:org_ship_request][:crew_role_id])
    if crew_role != nil
      if crew_role.owned_ship.user_in_crew(current_user) == false
        # BUG: this is very very broken lol
        @oscr = OwnedShipCrewRequest.new()
        @oscr.approval = new_approval(16, @owned_ship.character.user.id)
        @oscr.user_id = current_user.id
        @oscr.crew = crew_role

        if @oscr.save
          # flash[:success] = "Ship crew request made successfully."
          # redirect_to :action => "ship_crew_request"
          render status: 200, json: { message: 'Ship crew request made successfully' }
        else
          # flash[:danger] = "ERROR Occured: Ship crew request not made."
          # redirect_to :action => "ship_crew_request"
          render status: 200, json: { message: "Ship crew request not made because #{@oscr.errors.full_messages.to_sentence}" }
        end
      else
        # flash[:warning] = "You are already a member of this ships crew."
        # redirect_to :action => "ship_crew_request"
        render status: 400, json: { message: "You are already a member of this ships crew." }
      end
    else
      # flash[:danger] = 'Either the ship was not found or it is not a ship you own.'
      # redirect_to :action => 'ship_crew_request'
      render status: 400, json: { message: "Either the ship was not found or it is not a ship you own." }
    end
  end

  # GET api/requests/job-creation
  def job_creation_fetch

    @my_requests = JobBoardMissionCreationRequest.where(user_id: current_user.id)
    @criteria = JobBoardMissionCompletionCriterium.all
    render status: 200, json: { my_requests: @my_requests.as_json(include:{ job_board_mission: {}, approval:{ methods: [:approval_status, :created_at_ms] } }), criteria: @criteria }
  end

  # POST api/requests/job-creation
  # Body should contain job_board_mission
  def job_creation_post
    @req = JobBoardMissionCreationRequest.new
    @req.user_id = current_user.id
    @req.approval_id = new_approval(19)
    @req.job_board_mission = JobBoardMission.new(job_board_mission_params)
    @req.job_board_mission.posting_approved = false
    @req.job_board_mission.created_by_id = current_user.id
    @req.job_board_mission.updated_by_id = current_user.id
    @req.job_board_mission.mission_status_id = 1
    if @req.save
      render status: 200, json: { message: "Job request created." }
    else
      render status: 500, json: { message: "Error Occured: Job request could not be created." }
    end
  end

  # GET api/requests/system-map/
  # # TODO: REMOVE THIS to system map controller
  #
  def add_system_map_item_fetch
    # Also need to get all of this users requests
    render status: 200, json: {
      system_data: {
        systems: SystemMapSystem.where(approved: true),
        gravity_wells: SystemMapSystemGravityWell.where(approved: true),
        planets: SystemMapSystemPlanetaryBody.where(approved: true).as_json(methods: [:title_with_system]),
        moons: SystemMapSystemPlanetaryBodyMoon.where(approved: true),
        system_objects: SystemMapSystemObject.where(approved: true),
        settlements: SystemMapSystemSettlement.where(approved: true).as_json(methods: [:title_with_location]),
        object_types: SystemMapObjectKind.all,
        connection_sizes: SystemMapSystemConnectionSize.all
      },
      my_requests: AddSystemMapItemRequest.where(user_id: current_user.id).as_json(methods: [:object_title])
    }
  end

  # POST api/requests/system-map
  # DESC here
  def add_system_map_item_post
    # create the new system object
    # create request and approval
    if params[:object_type_id].to_i != nil
      # New systems
      if params[:object_type_id].to_i == 1
        newObject = SystemMapSystem.new
        newObject.title = params[:title]
        newObject.description = params[:description]
        newObject.approved = false
        newObject.discovered_by_id = current_user.id

        if newObject.save
          newRequest = AddSystemMapItemRequest.new
          newRequest.user_id = current_user.id
          newRequest.approval_id = new_approval(20)
          newRequest.system_map_object_kind = 1
          newRequest.kind_pk = newConnection.id

          if newRequest.save
            #connected_to_size_id, connected_to_id
            newConnection = SystemMapSystemConnection.new
            newConnection.system_one_id = newObject.id
            newConnection.system_two_id = params[:connected_to_id].to_i
            newConnection.system_map_system_connection_size_id = params[:connected_to_size_id].to_i
            newConnection.discovered_by_id = current_user.id

            if newConnection.save
              newRequest2 = AddSystemMapItemRequest.new
              newRequest2.user_id = current_user.id
              newRequest2.approval_id = new_approval(20)
              newRequest2.system_map_object_kind = 10
              newRequest2.kind_pk = newConnection.id

              if newRequest2.save
                render status: 200, json: { message: "New system and connection saved." }
              else
                render status: 500, json: { message: "Request for new system connection could not be saved." }
              end
            else
              render status: 500, json: { message: "New system was saved but new connection could not be saved."}
            end
          else
            render status: 500, json: { message: "Request could not be saved for the system." }
          end
        else
          render status: 500, json: { message: "New system could not be saved." }
        end

      # New Gravity Well
      elsif params[:object_type_id].to_i.to_i == 2
        newObject = SystemMapSystemGravityWell.new
        newObject.title = params[:title]
        newObject.description = params[:description]
        newObject.system_id = params[:system_id].to_i
        newObject.approved = false

        if newObject.save
          newRequest = AddSystemMapItemRequest.new
          newRequest.user_id = current_user.id
          newRequest.approval_id = new_approval(20)
          newRequest.system_map_object_kind_id = 2
          newRequest.kind_pk = newObject.id

          if newRequest.save
            render status: 200, json: { message: "New gravity well saved." }
          else
            render status: 500, json: { message: "Request for new gravity well could not be saved." }
          end
        else
          render status: 500, json: { message: "New gravity well could not be saved." }
        end

      # New planet
      elsif params[:object_type_id].to_i == 3
        newObject = SystemMapSystemPlanetaryBody.new
        newObject.title = params[:title]
        newObject.description = params[:description]
        newObject.orbits_system_id = params[:orbits_system_id].to_i
        newObject.approved = false
        newObject.discovered_by_id = current_user.id

        if newObject.save
          newRequest = AddSystemMapItemRequest.new
          newRequest.user_id = current_user.id
          newRequest.approval_id = new_approval(20)
          newRequest.system_map_object_kind_id = 3
          newRequest.kind_pk = newObject.id

          if newRequest.save
            render status: 200, json: { message: "New planet saved." }
          else
            render status: 500, json: { message: "Request for new gravity well could not be saved." }
          end
        else
          render status: 500, json: { message: "New gravity well could not be saved." }
        end

      # New Moon
      elsif params[:object_type_id].to_i == 4
        newObject = SystemMapSystemPlanetaryBodyMoon.new
        newObject.title = params[:title]
        newObject.description = params[:description]
        newObject.approved = false
        newObject.orbits_planet_id = params[:orbits_planet_id].to_i
        newObject.discovered_by_id = current_user.id

        if newObject.save
          newRequest = AddSystemMapItemRequest.new
          newRequest.user_id = current_user.id
          newRequest.approval_id = new_approval(20)
          newRequest.system_map_object_kind = 4
          newRequest.kind_pk = newObject.id

          if newRequest.save
            render status: 200, json: { message: "New moon saved." }
          else
            render status: 500, json: { message: "Request for new moon could not be saved." }
          end
        else
          render status: 500, json: { message: "New moon could not be saved." }
        end

      # New System Object
      elsif params[:object_type_id].to_i == 5
        newObject = SystemMapSystemObject.new
        newObject.title = params[:title]
        newObject.description = params[:description]
        newObject.approved = false
        newObject.discovered_by_id = current_user.id
        newObject.orbits_system_id = param[:orbits_system_id].to_i
        newObject.orbits_planet_id = param[:orbits_planet_id].to_i
        newObject.orbits_moon_id = param[:orbits_moon_id].to_i

        if newObject.save
          newRequest = AddSystemMapItemRequest.new
          newRequest.user_id = current_user.id
          newRequest.approval_id = new_approval(20)
          newRequest.system_map_object_kind = 5
          newRequest.kind_pk = newObject.id

          if newRequest.save
            render status: 200, json: { message: "New system object saved." }
          else
            render status: 500, json: { message: "Request for new system boject could not be saved." }
          end
        else
          render status: 500, json: { message: "New system object could not be saved." }
        end

      # New settlement
      elsif params[:object_type_id].to_i == 6
        newObject = SystemMapSystemSettlement.new
        newObject.title = params[:title]
        newObject.description = params[:description]
        newObject.approved = false
        newObject.on_planet_id = param[:on_planet_id].to_i
        newObject.on_moon_id = param[:on_moon_id].to_i
        newObject.discovered_by_id = current_user.id

        if newObject.save
          newRequest = AddSystemMapItemRequest.new
          newRequest.user_id = current_user.id
          newRequest.approval_id = new_approval(20)
          newRequest.system_map_object_kind = 6
          newRequest.kind_pk = newObject.id

          if newRequest.save
            render status: 200, json: { message: "New settlement saved." }
          else
            render status: 500, json: { message: "Request for new settlement could not be saved." }
          end
        else
          render status: 500, json: { message: "New settlement could not be saved." }
        end

      # New Location
      elsif params[:object_type_id].to_i == 7
        newObject = SystemMapSystemPlanetaryBodyLocation.new
        newObject.title = params[:title]
        newObject.description = params[:description]
        newObject.approved = false
        newObject.on_planet_id = param[:on_planet_id].to_i
        newObject.on_moon_id = param[:on_moon_id].to_i
        newObject.on_system_object_id = param[:on_system_object_id].to_i
        newObject.on_settlement_id = param[:on_settlement_id].to_i
        newObject.discovered_by_id = current_user.id

        if newObject.save
          newRequest = AddSystemMapItemRequest.new
          newRequest.user_id = current_user.id
          newRequest.approval_id = new_approval(20)
          newRequest.system_map_object_kind = 7
          newRequest.kind_pk = newObject.id

          if newRequest.save
            render status: 200, json: { message: "New location saved." }
          else
            render status: 500, json: { message: "Request for new location could not be saved." }
          end
        else
          render status: 500, json: { message: "New location could not be saved." }
        end

      elsif params[:object_type_id].to_i == 8
        newObject = SystemMapFauna.new
        newObject.title = params[:title]
        newObject.description = params[:description]
        newObject.approved = false
        newObject.on_planet_id = param[:on_planet_id].to_i
        newObject.on_moon_id = param[:on_moon_id].to_i
        newObject.on_system_object_id = param[:on_system_object_id].to_i
        newObject.discovered_by_id = current_user.id

        if newObject.save
          newRequest = AddSystemMapItemRequest.new
          newRequest.user_id = current_user.id
          newRequest.approval_id = new_approval(20)
          newRequest.system_map_object_kind = 8
          newRequest.kind_pk = newObject.id

          if newRequest.save
            render status: 200, json: { message: "New fauna saved." }
          else
            render status: 500, json: { message: "Request for new fauna could not be saved." }
          end
        else
          render status: 500, json: { message: "New fauna could not be saved." }
        end

      elsif params[:object_type_id].to_i == 9
        newObject = SystemMapFlora.new
        newObject.title = params[:title]
        newObject.description = params[:description]
        newObject.approved = false
        newObject.on_planet_id = param[:on_planet_id].to_i
        newObject.on_moon_id = param[:on_moon_id].to_i
        newObject.on_system_object_id = param[:on_system_object_id].to_i
        newObject.discovered_by_id = current_user.id

        if newObject.save
          newRequest = AddSystemMapItemRequest.new
          newRequest.user_id = current_user.id
          newRequest.approval_id = new_approval(20)
          newRequest.system_map_object_kind = 9
          newRequest.kind_pk = newObject.id

          if newRequest.save
            render status: 200, json: { message: "New flora saved." }
          else
            render status: 500, json: { message: "Request for new flora could not be saved." }
          end
        else
          render status: 500, json: { message: "New flora could not be saved." }
        end

      elsif params[:object_type_id].to_i == 10
        newObject = SystemMapSystemConnection.new
        newConnection.system_one_id = params[:system_one_id].to_i
        newConnection.system_two_id = params[:connected_to_id].to_i
        newConnection.system_map_system_connection_size_id = params[:system_map_system_connection_size_id].to_i
        newObject.approved = false
        newObject.discovered_by_id = current_user.id

        if newObject.save
          newRequest = AddSystemMapItemRequest.new
          newRequest.user_id = current_user.id
          newRequest.approval_id = new_approval(20)
          newRequest.system_map_object_kind = 10
          newRequest.kind_pk = newObject.id

          if newRequest.save
            render status: 200, json: { message: "New connection (jump point) saved." }
          else
            render status: 500, json: { message: "Request for new connection (jump point) could not be saved." }
          end
        else
          render status: 500, json: { message: "New connection (jump point) could not be saved." }
        end
      end
    else
      render status: 500, json: { message: "object_type_id missing." }
    end
  end

  ### ALL NEW APPROVAL REQUESTS GO ABOVE THIS POINT BELOW ARE RELATED TO APPROVALS ###

  # GET api/approvals/my
  def your_approvals
    # dont need to do anything here
  end

  # get api/approvals/:approval_id
  def approval_details
    @approval = Approval.find_by id: params[:approval_id].to_i
    if (@approval == nil || current_user.db_user.approval_approvers.where('approval_id = ?', params[:approval_id].to_i).count < 1)
      render status: 404, json: { message: "Approval not found." }
    else
      # the requested approval details
      render status: 200, json: ApprovalApprover.where("approval_id = ? AND user_id = ?", @approval.id, current_user.id).first
    end
  end
  private
  def position_change_params
    params.require(:position_change_request).permit(:job_id, :character_id)
  end

  private
  def role_request_params
    params.require(:role_request).permit(:username)
  end

  private
  def org_ship_request
    #params.require(:)
  end

  private
  def job_board_mission_params
    params.require(:job_board_mission).permit(:title, :description, :completion_criteria_id, :starts_when, :expires_when, :max_acceptors, :op_value, :system_id, :planet_id, :moon_id, :system_object_id, :location_id)
  end
end
