class SystemMapController < ApplicationController
  # 
  before_action :require_user
  before_action :require_member

  # temporary till system map is ready
  # system map role IDS: 22 - Editor, 23 - Admin (admins can delete/archive objects)
  # before_action except: [] do |a|
  #   a.require_one_role([9]) #for now CEO only :)
  # end

  #all methods except public ones and deletion methods are available to editors
  before_action only: [:update_location, :update_settlement, :update_system_object, :update_moon, :update_planet, :delete_atmo_comp, :update_atmo_comps] do |a|
   a.require_one_role([22,23]) #editor
  end

  # all others methods should only be available to admins
  before_action except: [:list, :update_location, :update_settlement, :update_system_object, :update_moon, :update_planet, :delete_atmo_comp, :update_atmo_comps] do |a|
   a.require_one_role([23]) #admin
  end


  # Types:
  # SystemMapSystem, SystemMapSystemConnection
  # SystemMapSystemPlanetaryBody, SystemMapSystemPlanetaryBodyType, SystemMapSystemPlanetaryBodyTypeIn
  # SystemMapSystemPlanetaryBodyMoon, SystemMapSystemPlanetaryBodyMoonType, SystemMapSystemPlanetaryBodyMoonTypeIn
  # SystemMapSystemObject, SystemMapSystemObjectType

  # Star Reference: http://www.enchantedlearning.com/subjects/astronomy/stars/startypes.shtml

  # GET api/system-map/
  def list
    render json: SystemMapSystem.where(archived: false).as_json(methods: [:kind, :primary_image_url, :primary_image_url_full], include: { planets: {}, faction_affiliation: {}, jurisdiction: {} })
  end

  # GET api/system-map/details
  def list_details
    # ready the json object!
    # intended for the map view
    render status: 200, json: SystemMapSystem.where(archived: false).as_json(methods: [:primary_image_url, :primary_image_url_full], include: {
        faction_affiliation: {},
        jurisdiction: { include: { categories: { include: { laws: {} } } } },
        discovered_by: { only: [], methods: [:main_character] },
        system_objects: { include: { mission_givers: { include: { faction_affiliation: { } }, methods: [:primary_image_url, :primary_image_url_full] }, jurisdiction: { include: { categories: { include: { laws: {} } } } }, flora: {}, fauna: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } }, object_type: {}, locations: { include: { mission_givers: { include: { faction_affiliation: { } }, methods: [:primary_image_url, :primary_image_url_full] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } } }, methods: [:primary_image_url, :primary_image_url_full] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url, :primary_image_url_full] },
        planets: { include: { jurisdiction: { include: { categories: { include: { laws: {} } } } }, flora: {}, fauna: {}, settlements: { include: { mission_givers: { include: { faction_affiliation: { } }, methods: [:primary_image_url, :primary_image_url_full] }, jurisdiction: { include: { categories: { include: { laws: {} } } } }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } }  }, locations: { include: { mission_givers: { include: { faction_affiliation: { } }, methods: [:primary_image_url, :primary_image_url_full] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } } }, methods: [:primary_image_url, :primary_image_url_full] } }, methods: [:primary_image_url, :primary_image_url_full] }, discovered_by: { only: [], methods: [:main_character] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } }, locations: { include: { mission_givers: { include: { faction_affiliation: { } }, methods: [:primary_image_url, :primary_image_url_full] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } } }, methods: [:primary_image_url, :primary_image_url_full] }, moons: { include: { jurisdiction: { include: { categories: { include: { laws: {} } } } }, flora: {}, fauna: {}, settlements: { include: { mission_givers: { include: { faction_affiliation: { } }, methods: [:primary_image_url, :primary_image_url_full] }, jurisdiction: { include: { categories: { include: { laws: {} } } } }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } }, locations: { include: { mission_givers: { include: { faction_affiliation: { } }, methods: [:primary_image_url, :primary_image_url_full] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } } }, methods: [:primary_image_url, :primary_image_url_full] } }, methods: [:primary_image_url, :primary_image_url_full] }, discovered_by: { only: [], methods: [:main_character] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } }, locations: { include: { mission_givers: { include: { faction_affiliation: { } }, methods: [:primary_image_url, :primary_image_url_full] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } } }, methods: [:primary_image_url, :primary_image_url_full] }, moon_types: {}, system_objects: { include: { mission_givers: { include: { faction_affiliation: { } }, methods: [:primary_image_url, :primary_image_url_full] }, jurisdiction: { include: { categories: { include: { laws: {} } } } }, flora: {}, fauna: {}, object_type: {}, locations: { include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } } }, methods: [:primary_image_url, :primary_image_url_full] } }, methods: [:primary_image_url, :primary_image_url_full] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url, :primary_image_url_full] }, planet_types: {}, system_objects: { include: { mission_givers: { include: { faction_affiliation: { } }, methods: [:primary_image_url, :primary_image_url_full] }, jurisdiction: { include: { categories: { include: { laws: {} } } } }, flora: {}, fauna: {}, object_type: {}, locations: { include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } } }, methods: [:primary_image_url, :primary_image_url_full] } }, methods: [:primary_image_url, :primary_image_url_full] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url, :primary_image_url_full] },
        gravity_wells: { include: { discovered_by: { only: [], methods: [:main_character] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } }, gravity_well_type: { }, luminosity_class: { } }, methods: [:primary_image_url, :primary_image_url_full] } }
        )
  end

  # GET api/system-map/types
  # DEPRECATED/DO NOT USE
  # def list_types
  #   @gravity_well_types = SystemMapSystemGravityWellType.all
  #   @planetary_body_types = SystemMapSystemPlanetaryBodyType.all
  #   @moon_types = SystemMapSystemPlanetaryBodyMoonType.all
  #   @gw_lum_classes = SystemMapSystemGravityWellLuminosityClass.all
  #   @jp_sizes = SystemMapSystemConnectionSize.all
  #   @jp_statues = SystemMapSystemConnectionStatus.all
  #   @system_object_types = SystemMapSystemObjectType.all
  #   @location_types = SystemMapSystemPlanetaryBodyLocationType.all.order("title asc")

  #   render :json => {
  #                     :gravity_well_types => @gravity_well_types.as_json,
  #                     :planetary_body_types => @planetary_body_types.as_json,
  #                     :moon_types => @moon_types.as_json,
  #                     :gw_lum_classes => @gw_lum_classes.as_json,
  #                     :jp_sizes => @jp_sizes.as_json,
  #                     :jp_statues => @jp_statues.as_json,
  #                     :system_object_types => @system_object_types.as_json,
  #                     :location_types => @location_types.as_json
  #                   }
  # end

  # POST api/system-map
  # Body should contain system_object
  def create
    begin
      @system = SystemMapSystem.create(system_create_params)

      @system.discovered_by_id = current_user.id

      @system.gravity_wells << SystemMapSystemGravityWell.create(title: @system.title, discovered_by_id: current_user.id)

      if @system.save
        render status: 200, json: { message: 'Created new star system!' }
      else
        render status: 500, json: { message: "ERROR Occured: New system could not be created because: #{@system.errors.full_messages.to_sentence}"}
      end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: New system could not be created: " + e.message}
    end
  end

  # PUT api/system-map
  def update
    begin
      @system = SystemMapSystem.find_by_id(params[:system][:id])
      if @system != nil
        if @system.update_attributes(system_create_params)
          # if params[:fix_types] && params[:fix_types] == true
          #   @system = fix_system_types(@system, params)
          # end
          # @system = fix_discovered_by(@system)
          # @system.save
          render status: 200, json: { message: 'Success' }
        else
          render status: 500, json: { message: "ERROR Occured: System could not be edited because: #{@system.errors.full_messages.to_sentence}"}
        end
      else
        render status: 404, json: { message: 'Star System not found.' }
      end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: System could not be edited. The following error occured: " + e.message}
    end
  end

  # def update_atmo_comps
  #   saveCount = 0
  #   params[:atmo_compositions].each do |comp|
  #     if comp[:id] != nil
  #       # then we are updating
  #       @compo = SystemMapAtmoComposition.find_by_id(params[:comp_id].to_i)
  #       if @compo != nil
  #         @compo.atmo_gas_id = comp[:atmo_gas][:id]
  #         @compo.for_planet_id = comp[:for_planet_id]
  #         @compo.for_moon_id = comp[:for_moon_id]
  #         @compo.for_system_object_id = comp[:for_system_object_id]
  #         @compo.percentage = comp[:percentage]
  #         if @compo.save
  #           saveCount = saveCount + 1
  #         end
  #       else
  #         render status: 404, json: { message: "Atmo comp not found" }
  #         return
  #       end
  #     else
  #       #then we are creating
  #       if SystemMapAtmoComposition.create(
  #         atmo_gas_id: comp[:atmo_gas][:id],
  #         for_planet_id: comp[:for_planet_id],
  #         for_moon_id: comp[:for_moon_id],
  #         for_system_object_id: comp[:for_system_object_id],
  #         percentage: comp[:percentage]
  #       )
  #         saveCount = saveCount + 1
  #       end
  #     end
  #   end #end comps loop
  #   if params[:atmo_compositions].count == saveCount
  #     render status: 200, json: { message: "Composition created or updated!" }
  #   else
  #     render status: 500, json: { message: "Errors occured. Not all comps created or updated." }
  #   end
  # end

  # def delete_atmo_comp
  #   @compo = SystemMapAtmoComposition.find_by_id(params[:comp_id].to_i)
  #   if @compo != nil
  #     if @compo.destroy
  #       render status: 200, json: { message: "Atmo composition removed" }
  #     else
  #       render status: 500, json: { message: "ERROR: Could not delete atmo comp" }
  #     end
  #   else
  #     render status: 404, json: { message: "Atmo composition not found." }
  #   end
  # end

  #get
  # system-map/fetch-known-gases
  def fetch_known_atmo_gases
    render status: 200, json: { known_gases: SystemMapAtmoGase.all }
  end

  #https://github.com/thinkphp/dijkstra.gem
  def fastest_path_between_systems
    #expects params[:system_start], params[:system_end]
    if (params[:system_start] != nil && params[:system_end] != nil)
      connections = SystemMapSystemConnection.where("system_map_system_connection_status_id NOT IN (1,4)")
      paths = []
      connections.each do |connection|
        paths << [connection.system_one_id, connection.system_two_id, 1]
      end

      ob = Dijkstra.new(params[:system_start].to_i, params[:system_end].to_i, paths)
      # number of jumps - ob.cost
      # shortest path - ob.shortest_path
      render json: { :path => ob }
      #how how do we return this
    else
      render :nothing => true, :status => 500
    end
  end

  private
  def system_create_params
    params.require(:system).permit(:title, :description, :tags, :jurisdiction_id, :faction_affiliation_id)
    # Old silly 'universal' update idea
    # params.require(:system).permit(:id,
    #                                :title,
    #                                :description,
    #                                :jurisdiction_id,
    #                                system_objects_attributes: [:id,
    #                                                            :title,
    #                                                            :description,
    #                                                            :object_type_id],
    #                                gravity_wells_attributes: [:id,
    #                                                           :title,
    #                                                           :description,
    #                                                           :luminosity_class_id,
    #                                                           :gravity_well_type_id],
    #                                planets_attributes: [:id,
    #                                                     :title,
    #                                                     :description,
    #                                                     moons_attributes:[:id,
    #                                                                       :title,
    #                                                                       :description,
    #                                                                       moon_types: [:id],
    #                                                                       system_objects_attributes: [:id, :title, :description, :object_type_id],
    #                                                                       locations_attributes: [:id, :title, :description]
    #                                                                       ],
    #                                                     system_objects_attributes: [:id, :title, :description, :object_type_id],
    #                                                     planet_types_attributes: [:id],
    #                                                     locations_attributes: [:id, :title, :description]
    #                                                     ])
  end
end
