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
    # ready the json object!
    render status: 200, json: SystemMapSystem.all.as_json(include: {
        discovered_by: { only: [], methods: [:main_character] },
        system_objects: { include: { flora: {}, fauna: {}, observations: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } }, object_type: {}, locations: { methods: [:primary_image_url] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url] },
        planets: { include: { flora: {}, fauna: {}, settlements: { include: { locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, observations: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } }, locations: { include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } } }, methods: [:primary_image_url] }, moons: { include: { flora: {}, fauna: {}, settlements: { include: { locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, observations: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } }, locations: { methods: [:primary_image_url] }, moon_types: {}, system_objects: { include: { flora: {}, fauna: {}, object_type: {}, locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url] }, planet_types: {}, system_objects: { include: { flora: {}, fauna: {}, object_type: {}, locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url] },
        gravity_wells: { include: { observations: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only: [], methods: [:main_character] } } }, gravity_well_type: { }, luminosity_class: { } }, methods: [:primary_image_url] } },
        methods: :jump_points)

  end

  def fetch_locations
    @locations = SystemMapSystemPlanetaryBodyLocation.all
    render json: @locations
  end

  # GET api/system-map/types
  def list_types
    @gravity_well_types = SystemMapSystemGravityWellType.all
    @planetary_body_types = SystemMapSystemPlanetaryBodyType.all
    @moon_types = SystemMapSystemPlanetaryBodyMoonType.all
    @gw_lum_classes = SystemMapSystemGravityWellLuminosityClass.all
    @jp_sizes = SystemMapSystemConnectionSize.all
    @jp_statues = SystemMapSystemConnectionStatus.all
    @system_object_types = SystemMapSystemObjectType.all
    @location_types = SystemMapSystemPlanetaryBodyLocationType.all.order("title asc")

    render :json => {
                      :gravity_well_types => @gravity_well_types.as_json,
                      :planetary_body_types => @planetary_body_types.as_json,
                      :moon_types => @moon_types.as_json,
                      :gw_lum_classes => @gw_lum_classes.as_json,
                      :jp_sizes => @jp_sizes.as_json,
                      :jp_statues => @jp_statues.as_json,
                      :system_object_types => @system_object_types.as_json,
                      :location_types => @location_types.as_json
                    }
  end

  # POST api/tools/system-map
  # Body should contain system_object
  def create
    begin
      puts
      puts system_create_params
      if SystemMapSystem.create(system_create_params)
        render status: 200, json: { message: "Success" }
      else
        render status: 500, json: { message: "ERROR Occured: New system could not be saved."}
      end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: New system could not be saved: " + e.message}
    end
  end


  def update
    begin
      puts 'Universal system update for...'
      puts 'System Id: ' + params[:system][:id]
      puts ''
      @system = SystemMapSystem.find_by_id(params[:system][:id].to_i)
      if @system != nil
        if @system.update_attributes(system_create_params)
          # if params[:fix_types] && params[:fix_types] == true
          #   @system = fix_system_types(@system, params)
          # end
          # @system = fix_discovered_by(@system)
          # @system.save
          render status: 200, json: { message: "Success" }
        else
          render status: 500, json: { message: "ERROR Occured: System could not be edited."}
        end
      else
        render status: 404, json: { message: "Star System not found." }
      end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: System could not be edited. The following error occured: " + e.message}
    end
  end

  def delete_gravity_well
    begin
        @obj = SystemMapSystemGravityWell.find_by_id(params[:gravity_well_id].to_i)
        if @obj != nil
          if @obj.destroy
            render status: 200, json: { message: "Success" }
          else
            render status: 500, json: { message: "ERROR Occured: Gravity well could not be rmeoved."}
          end
        else
          render status: 404, json: { message: "Gravity well not found." }
        end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: New system could not be deleted: " + e.message}
    end
  end

  # POST api/system-map/planet
  def add_planet
    @planet = SystemMapSystemPlanetaryBody.new

    @planet.title = params[:planet][:title]
    @planet.description = params[:planet][:description]
    @planet.orbits_system_id = params[:planet][:orbits_system_id]
    @planet.population_density = params[:planet][:population_density]
    @planet.economic_rating = params[:planet][:economic_rating]
    @planet.general_radiation = params[:planet][:general_radiation]
    @planet.atmo_pressure = params[:planet][:atmo_pressure]
    @planet.tempature_min = params[:planet][:tempature_min]
    @planet.tempature_max = params[:planet][:tempature_max]
    @planet.minimum_criminality_rating = params[:planet][:minimum_criminality_rating]

    @planet.discovered_by = current_user

    if params[:planet][:new_primary_image] != nil
      if @planet.primary_image != nil
        @planet.primary_image.image = params[:planet][:new_primary_image][:base64]
        @planet.primary_image.image_file_name = params[:planet][:new_primary_image][:name]
      else
        @planet.primary_image = SystemMapImage.create(image: params[:planet][:new_primary_image][:base64], image_file_name: params[:planet][:new_primary_image][:name], title: @moon.title, description: @moon.title)
      end
    end
    #img = ImageUpload.create(image: "data:#{image[:image][:filetype]};base64,#{image[:image][:base64]}", image_file_name: image[:image][:filename], title: image[:title], description: image[:description], uploaded_by: current_user)

    if @planet.save
      render status: 200, json: @planet.as_json(include: { flora: {}, fauna: {}, settlements: { include: { locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, observations: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: {}, locations: { include: { system_map_images: {} }, methods: [:primary_image_url] }, moons: { include: { flora: {}, fauna: {}, settlements: { include: { locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, observations: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: {}, locations: { methods: [:primary_image_url] }, moon_types: {}, system_objects: { include: { flora: {}, fauna: {}, object_type: {}, locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url] }, planet_types: {}, system_objects: { include: { flora: {}, fauna: {}, object_type: {}, locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url])
    else
      render status: 500, json: { message: "Planet could not be created because: #{@planet.errors.full_messages.to_sentence}." }
    end
  end

  # PATCH|PUT api/system-map/planet
  def update_planet
    @planet = SystemMapSystemPlanetaryBody.find_by_id(params[:planet][:id].to_i)
    if @planet != nil
      @planet.title = params[:planet][:title]
      @planet.description = params[:planet][:description]
      @planet.orbits_system_id = params[:planet][:orbits_system_id]
      @planet.population_density = params[:planet][:population_density]
      @planet.economic_rating = params[:planet][:economic_rating]
      @planet.general_radiation = params[:planet][:general_radiation]
      @planet.atmo_pressure = params[:planet][:atmo_pressure]
      @planet.tempature_min = params[:planet][:tempature_min]
      @planet.tempature_max = params[:planet][:tempature_max]
      @planet.minimum_criminality_rating = params[:planet][:minimum_criminality_rating]
      if params[:planet][:new_primary_image] != nil
        if @planet.primary_image != nil
          @planet.primary_image.image = params[:planet][:new_primary_image][:base64]
          @planet.primary_image.image_file_name = params[:planet][:new_primary_image][:name]
        else
          @planet.primary_image = SystemMapImage.create(image: params[:planet][:new_primary_image][:base64], image_file_name: params[:planet][:new_primary_image][:name], title: @planet.title, description: @planet.title)
        end
      end
      #img = ImageUpload.create(image: "data:#{image[:image][:filetype]};base64,#{image[:image][:base64]}", image_file_name: image[:image][:filename], title: image[:title], description: image[:description], uploaded_by: current_user)

      if @planet.save
        render status: 200, json: @planet.as_json(include: { flora: {}, fauna: {}, settlements: { include: { locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, observations: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: {}, locations: { include: { system_map_images: {} }, methods: [:primary_image_url] }, moons: { include: { flora: {}, fauna: {}, settlements: { include: { locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, observations: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: {}, locations: { methods: [:primary_image_url] }, moon_types: {}, system_objects: { include: { flora: {}, fauna: {}, object_type: {}, locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url] }, planet_types: {}, system_objects: { include: { flora: {}, fauna: {}, object_type: {}, locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url])
      else
        render status: 500, json: { message: "Planet could not be updated because: #{@planet.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: "Planet not found" }
    end
  end

  # DELETE api/system-map/planet/:planet_id
  def delete_planet
    begin
        @planet = SystemMapSystemPlanetaryBody.find_by_id(params[:planet_id].to_i)
        if @planet != nil
          @planet.archived = true
          if @planet.save
            render status: 200, json: { message: "Planet archived." }
          else
            render status: 500, json: { message: "ERROR Occured: Planet could not be rmeoved."}
          end
        else
          render status: 404, json: { message: "Gravity well not found." }
        end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: Planet could not be deleted: " + e.message}
    end
  end

  # POST api/system-map/moon
  def add_moon
    @moon = SystemMapSystemPlanetaryBodyMoon.new()
    # :title, :description, :orbits_planet_id
    @moon.title = params[:moon][:title]
    @moon.description = params[:moon][:description]
    @moon.orbits_planet_id = params[:moon][:orbits_planet_id]
    @moon.population_density = params[:moon][:population_density]
    @moon.economic_rating = params[:moon][:economic_rating]
    @moon.general_radiation = params[:moon][:general_radiation]
    @moon.atmo_pressure = params[:moon][:atmo_pressure]
    @moon.tempature_min = params[:moon][:tempature_min]
    @moon.tempature_max = params[:moon][:tempature_max]
    @moon.tempature_min = params[:moon][:tempature_min]
    @moon.minimum_criminality_rating = params[:moon][:minimum_criminality_rating]

    @moon.discovered_by = current_user

    if params[:moon][:new_primary_image] != nil
      if @moon.primary_image != nil
        @moon.primary_image.image = params[:moon][:new_primary_image][:base64]
        @moon.primary_image.image_file_name = params[:moon][:new_primary_image][:name]
      else
        @moon.primary_image = SystemMapImage.create(image: params[:moon][:new_primary_image][:base64], image_file_name: params[:moon][:new_primary_image][:name], title: @moon.title, description: @moon.title)
      end
    end
    if @moon.save
      render status: 201, json: @moon.as_json(include: { flora: {}, fauna: {}, settlements: { include: { locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, observations: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: {}, locations: { methods: [:primary_image_url] }, moon_types: {}, system_objects: { include: { flora: {}, fauna: {}, object_type: {}, locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url])
    else
      render status: 500, json: { message: "Moon could not be created because: #{@moon.errors.full_messages.to_sentence}" }
    end
  end

  # PATCH/PUT api/system-map/moon
  def update_moon
    @moon = SystemMapSystemPlanetaryBodyMoon.find_by_id(params[:moon][:id].to_i)
    if @moon != nil

      @moon.title = params[:moon][:title]
      @moon.description = params[:moon][:description]
      @moon.population_density = params[:moon][:population_density]
      @moon.economic_rating = params[:moon][:economic_rating]
      @moon.general_radiation = params[:moon][:general_radiation]
      @moon.atmo_pressure = params[:moon][:atmo_pressure]
      @moon.tempature_min = params[:moon][:tempature_min]
      @moon.tempature_max = params[:moon][:tempature_max]
      @moon.minimum_criminality_rating = params[:moon][:minimum_criminality_rating]

      if params[:moon][:new_primary_image] != nil
        if @moon.primary_image != nil
          @moon.primary_image.image = params[:moon][:new_primary_image][:base64]
          @moon.primary_image.image_file_name = params[:moon][:new_primary_image][:name]
        else
          @moon.primary_image = SystemMapImage.create(image: params[:moon][:new_primary_image][:base64], image_file_name: params[:moon][:new_primary_image][:name], title: @moon.title, description: @moon.title)
        end
      end
      if @moon.update_attributes(moon_params)
        render status: 200, json: @moon.as_json(include: { flora: {}, fauna: {}, settlements: { include: { locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, observations: {}, discovered_by: { only: [], methods: [:main_character] }, system_map_images: {}, locations: { methods: [:primary_image_url] }, moon_types: {}, system_objects: { include: { flora: {}, fauna: {}, object_type: {}, locations: { methods: [:primary_image_url] } }, methods: [:primary_image_url] }, atmo_compositions: { include: { atmo_gas: {} } } }, methods: [:primary_image_url])
      else
        render status: 500, json: { message: "Moon could not be created" }
      end
    else
      #
      render status: 404, json: { message: "Moon not found. You lost a moon??" }
    end
  end

  # DELETE api/system-map/moon/:moon_id
  def delete_moon
    begin
        @moon = SystemMapSystemPlanetaryBodyMoon.find_by_id(params[:moon_id].to_i)
        if @moon != nil
          @moon.archived = true
          if @moon.save
            render status: 200, json: { message: "Moon archived." }
          else
            render status: 500, json: { message: "ERROR Occured: Moon could not be removed."}
          end
        else
          render status: 404, json: { message: "Moon not found." }
        end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: Moon could not be saved: " + e.message}
    end
  end

  def add_system_object
    begin
        @so = SystemMapSystemObject.new()
        @so.title = params[:system_object][:title]
        @so.description = params[:system_object][:description]
        @so.object_type_id = params[:system_object][:object_type_id]
        @so.orbits_planet_id = params[:system_object][:orbits_planet_id]
        @so.orbits_moon_id = params[:system_object][:orbits_moon_id]
        if params[:system_object][:new_primary_image] != nil
          if @so.primary_image != nil
            @so.primary_image.image = params[:system_object][:new_primary_image][:base64]
            @so.primary_image.image_file_name = params[:system_object][:new_primary_image][:name]
          else
            @so.primary_image = SystemMapImage.create(image: params[:system_object][:new_primary_image][:base64], image_file_name: params[:system_object][:new_primary_image][:name], title: @so.title, description: @so.title)
          end
        end

        if @so.save
          render status: 200, json: { message: "Success" }
        else
          render status: 500, json: { message: "System object could not be created because: #{@so.errors.full_messages.to_sentence}"}
        end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: New system could not be saved: " + e.message}
    end
  end

  def update_system_object
    begin
        @so = SystemMapSystemObject.find_by_id(params[:so_id].to_i)
        if @so != nil
          @so.title = params[:system_object][:title]
          @so.description = params[:system_object][:description]
          @so.object_type_id = params[:system_object][:object_type_id]
          @so.orbits_planet_id = params[:system_object][:orbits_planet_id]
          @so.orbits_moon_id = params[:system_object][:orbits_moon_id]
          if params[:system_object][:new_primary_image] != nil
            if @so.primary_image != nil
              @so.primary_image.image = params[:system_object][:new_primary_image][:base64]
              @so.primary_image.image_file_name = params[:system_object][:new_primary_image][:name]
            else
              @so.primary_image = SystemMapImage.create(image: params[:system_object][:new_primary_image][:base64], image_file_name: params[:system_object][:new_primary_image][:name], title: @so.title, description: @so.title)
            end
          end

          @so.discovered_by = current_user

          if @so.save
            render status: 200, json: { message: "Success" }
          else
            render status: 500, json: { message: "System object could not be updated because: #{@so.errors.full_messages.to_sentence}"}
          end
        else
          render status: 404, json: { message: "System object not found." }
        end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: New system could not be saved: " + e.message}
    end
  end

  def delete_system_object
    begin
        @so = SystemMapSystemObject.find_by_id(params[:so_id].to_i)
        if @so != nil
          @so.archived = true
          if @so.save
            render status: 200, json: { message: "Success" }
          else
            render status: 500, json: { message: "ERROR Occured: Gravity well could not be rmeoved."}
          end
        else
          render status: 404, json: { message: "Gravity well not found." }
        end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: New system could not be saved: " + e.message}
    end
  end

  def add_settlement
    @settlement = SystemMapSystemSettlement.new
    if params[:settlement][:new_primary_image] != nil
      if @settlement.primary_image != nil
        @settlement.primary_image.image = params[:settlement][:new_primary_image][:base64]
        @settlement.primary_image.image_file_name = params[:settlement][:new_primary_image][:name]
      else
        @settlement.primary_image = SystemMapImage.create(image: params[:settlement][:new_primary_image][:base64], image_file_name: params[:settlement][:new_primary_image][:name], title: @settlement.title, description: @settlement.title)
      end
    end
    @settlement.title = params[:settlement][:title]
    @settlement.description = params[:settlement][:description]
    @settlement.on_planet_id = params[:settlement][:on_planet_id]
    @settlement.on_moon_id = params[:settlement][:on_moon_id]

    @settlement.discovered_by = current_user

    if @settlement.save
      render status: 200, json: @settlement
    else
      render status: 500, json: { message: "ERROR Occured: New settlement could not be saved."}
    end
  end

  def update_settlement
    @settlement = SystemMapSystemSettlement.find_by_id(params[:settlement][:id].to_i)
    if @settlement != nil
      if params[:settlement][:new_primary_image] != nil
        if @settlement.primary_image != nil
          @settlement.primary_image.image = params[:settlement][:new_primary_image][:base64]
          @settlement.primary_image.image_file_name = params[:settlement][:new_primary_image][:name]
        else
          new_primary_image = SystemMapImage.create(image: params[:settlement][:new_primary_image][:base64], image_file_name: params[:settlement][:new_primary_image][:name])
          @settlement.primary_image = new_primary_image
        end
      end
      @settlement.title = params[:settlement][:title]
      @settlement.description = params[:settlement][:description]
      @settlement.on_planet_id = params[:settlement][:on_planet_id]
      @settlement.on_moon_id = params[:settlement][:on_moon_id]

      if @settlement.save
        render status: 200, json: { message: "Success" }
      else
        render status: 500, json: { message: "ERROR Occured: New system could not be saved: " + e.message}
      end
    else
      render status: 404, json: { message: "Settlement not found." }
    end
  end

  def delete_settlement
    @settlement = SystemMapSystemSettlement.find_by_id(params[:settlement_id].to_i)
    if @settlement != nil
      if @settlement.destroy
        render status: 200, json: { message: "Success" }
      else
        render status: 500, json: { message: "ERROR Occured: New system could not be saved: " + e.message}
      end
    else
      render status: 404, json: { message: "Settlement not found." }
    end
  end

  def add_location
    #@locations = SystemMapSystemPlanetaryBodyLocation.create(location_params)
    @location = SystemMapSystemPlanetaryBodyLocation.new

    if params[:location][:new_primary_image] != nil
      if @location.primary_image != nil
        @location.primary_image.image = params[:location][:new_primary_image][:base64]
        @location.primary_image.image_file_name = params[:location][:new_primary_image][:name]
      else
        @location.primary_image = SystemMapImage.create(image: params[:location][:new_primary_image][:base64], image_file_name: params[:location][:new_primary_image][:name], title: @location.title, description: @location.title)
      end
    end

    @location.title = params[:location][:title]
    @location.description = params[:location][:description]
    @location.on_planet_id = params[:location][:on_planet_id]
    @location.on_moon_id = params[:location][:on_moon_id]
    @location.on_system_object_id = params[:location][:on_system_object_id]
    @location.on_settlement_id = params[:location][:on_settlement_id]
    @location.discovered_by = current_user

    if @location.save
      render status: 200, json: @location
    else
      render status: 500, json: { message: "Location could not be created because: #{@location.errors.full_messages.to_sentence}"}
    end
  end

  def update_location
    @location = SystemMapSystemPlanetaryBodyLocation.find_by_id(params[:location][:id].to_i)
    if @location != nil

      # check for a new primary image
      if params[:location][:new_primary_image] != nil
        if @location.primary_image != nil
          @location.primary_image.image = params[:location][:new_primary_image][:base64]
          @location.primary_image.image_file_name = params[:location][:new_primary_image][:name]
        else
          new_primary_image = SystemMapImage.create(image: params[:location][:new_primary_image][:base64], image_file_name: params[:location][:new_primary_image][:name])
          @location.primary_image = new_primary_image
        end
      end

      @location.title = params[:location][:title]
      @location.description = params[:location][:description]
      @location.on_planet_id = params[:location][:on_planet_id]
      @location.on_moon_id = params[:location][:on_moon_id]
      @location.on_system_object_id = params[:location][:on_system_object_id]
      @location.on_settlement_id = params[:location][:on_settlement_id]

      if @location.save
        render status: 200, json: @location
      else
        render status: 500, json: { message: "Location could not be updated because: #{@location.errors.full_messages.to_sentence}"}
      end
    else
      render status: 404, json: { message: "Location not found." }
    end
  end

  def delete_location
    @location = SystemMapSystemPlanetaryBodyLocation.find_by_id(params[:location_id].to_i)
    if @location != nil
      if @location.destroy
        render status: 200, json: { message: "Success" }
      else
        render status: 500, json: { message: "Location could not be archived because: #{@location.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: "Settlement not found." }
    end
  end

  def add_flora
    #SystemMapFlora
    #SsaveCount = 0
    #params[:new_flora].each do |loc|
    @flora = SystemMapFlora.new

    if params[:new_flora][:new_primary_image] != nil
      new_primary_image = SystemMapImage.create(image: "data:#{params[:new_flora][:new_primary_image][:filetype]};base64,#{params[:new_flora][:new_primary_image][:base64]}", image_file_name: params[:new_flora][:new_primary_image][:filename])
      @flora.primary_image = new_primary_image
    else
      @flora.primary_image = SystemMapImage.new
    end

    @flora.title = params[:new_flora][:title]
    @flora.description = params[:new_flora][:description]
    @flora.on_planet_id = params[:new_flora][:on_planet_id]
    @flora.on_moon_id = params[:new_flora][:on_moon_id]
    @flora.on_system_object_id = params[:new_flora][:on_system_object_id]
    @flora.discovered_by = current_user

    if @flora.save
      render status: 200, json: { message: "Success" }
    else
      render status: 500, json: { message: "ERROR Occured: New settlement could not be saved."}
    end
  end

  def update_flora
    @flora = SystemMapFlora.find_by_id(params[:new_flora][:id])
    if @flora != nil
      if params[:new_flora][:new_primary_image] != nil
        new_primary_image = SystemMapImage.create(image: "data:#{params[:new_flora][:new_primary_image][:filetype]};base64,#{params[:new_flora][:new_primary_image][:base64]}", image_file_name: params[:new_flora][:new_primary_image][:filename])
        @flora.primary_image = new_primary_image
      else
        @flora.primary_image = SystemMapImage.new
      end

      @flora.title = params[:new_flora][:title]
      @flora.description = params[:new_flora][:description]
      @flora.on_planet_id = params[:new_flora][:on_planet_id]
      @flora.on_moon_id = params[:new_flora][:on_moon_id]
      @flora.on_system_object_id = params[:new_flora][:on_system_object_id]
      @flora.discovered_by = current_user

      if @flora.save
        render status: 200, json: { message: "Success" }
      else
        render status: 500, json: { message: "ERROR Occured: New settlement could not be saved."}
      end
    else
      render status: 404, json: { message: "Flora not found."}
    end
  end

  def delete_flora
    @flora = SystemMapFlora.find_by_id(params[:fauna_id])
    if @flora != nil
      if @flora.destroy
        render status: 200, json: { message: "Success" }
      else
        render status: 500, json: { message: "ERROR Occured: New settlement could not be saved."}
      end
    else
      render status: 404, json: { message: "Flora not found."}
    end
  end

  def add_fauna
    #SystemMapFauna
    @fauna = SystemMapFauna.new

    if params[:new_fauna][:new_primary_image] != nil
      new_primary_image = SystemMapImage.create(image: "data:#{params[:new_fauna][:new_primary_image][:filetype]};base64,#{params[:new_fauna][:new_primary_image][:base64]}", image_file_name: params[:new_fauna][:new_primary_image][:filename])
      @fauna.primary_image = new_primary_image
    else
      @fauna.primary_image = SystemMapImage.new
    end

    @fauna.title = params[:new_fauna][:title]
    @fauna.description = params[:new_fauna][:description]
    @fauna.on_planet_id = params[:new_fauna][:on_planet_id]
    @fauna.on_moon_id = params[:new_fauna][:on_moon_id]
    @fauna.on_system_object_id = params[:new_fauna][:on_system_object_id]
    @fauna.discovered_by = current_user

    if @fauna.save
      render status: 200, json: { message: "Success" }
    else
      render status: 500, json: { message: "ERROR Occured: New settlement could not be saved."}
    end
  end

  def update_fauna
    @fauna = SystemMapFauna.find_by_id(params[:new_fauna][:id])

    if @fauna != nil
      if params[:new_fauna][:new_primary_image] != nil
        new_primary_image = SystemMapImage.create(image: "data:#{params[:new_fauna][:new_primary_image][:filetype]};base64,#{params[:new_fauna][:new_primary_image][:base64]}", image_file_name: params[:new_fauna][:new_primary_image][:filename])
        @fauna.primary_image = new_primary_image
      else
        @fauna.primary_image = SystemMapImage.new
      end

      @fauna.title = params[:new_fauna][:title]
      @fauna.description = params[:new_fauna][:description]
      @fauna.on_planet_id = params[:new_fauna][:on_planet_id]
      @fauna.on_moon_id = params[:new_fauna][:on_moon_id]
      @fauna.on_system_object_id = params[:new_fauna][:on_system_object_id]
      @fauna.discovered_by = current_user

      if @fauna.save
        render status: 200, json: { message: "Success" }
      else
        render status: 500, json: { message: "ERROR Occured: New settlement could not be saved."}
      end
    else
      render status: 404, json: { message: "Fauna not found."}
    end
  end

  def delete_fauna
    @fauna = SystemMapFauna.find_by_id(params[:new_fauna][:id])

    if @fauna != nil
      if @fauna.destroy
        render status: 200, json: { message: "Success" }
      else
        render status: 500, json: { message: "ERROR Occured: New settlement could not be saved."}
      end
    else
      render status: 404, json: { message: "Flora not found."}
    end
  end

  # POST api/system-map/image
  def add_system_image
    begin
      @image = SystemMapImage.new(system_image_params)
      @image.image = params[:image][:new_image][:base64]
      @image.image_file_name = params[:image][:new_image][:name]

      @image.created_by = current_user

      #If its the system objects first image make it the default image
      #:of_system_id, :of_planet_id, :of_moon_id, :of_system_object_id, :of_settlement_id, :of_location_id, :of_gravity_well_id
      # if @image.of_system_id != nil && @image.of_system_id != 0
      #   @image.is_default_image = true unless @image.of_system.system_map_images.count > 0
      #
      # elsif @image.of_planet_id != nil && @image.of_planet_id != 0
      #   @image.is_default_image = true unless @image.of_planet_id.system_map_images.count > 0
      #
      # elsif @image.of_moon_id != nil && @image.of_moon_id != 0
      #   @image.is_default_image = true unless @image.of_moon_id.system_map_images.count > 0
      #
      # elsif @image.of_system_object_id != nil && @image.of_system_object_id != 0
      #   @image.is_default_image = true unless @image.of_system_object_id.system_map_images.count > 0
      #
      # elsif @image.of_location_id != nil && @image.of_location_id != 0
      #   @image.is_default_image = true unless @image.of_location_id.system_map_images.count > 0
      #
      # elsif @image.of_gravity_well_id != nil && @image.of_gravity_well_id != 0
      #   @image.is_default_image = true unless @image.of_gravity_well_id.system_map_images.count > 0
      # end

      if @image.save
        render status: 200, json: @image.as_json(include: { created_by: { only: [:id, :username], methods: [:main_character] } })
      else
        render status: 500, json: {message: "System Image could not be created because: #{@image.errors.full_messages.to_sentence}"}
      end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: New image could not be saved: " + e.message}
    end
  end

  # PATCH|PUT api/system-map/image
  def update_system_image
    @image = SystemMapImage.find_by_id(params[:image][:id])
    if @image
      if params[:image][:new_image]
        @image.image = params[:image][:new_image][:base64]
        @image.image_file_name = params[:image][:new_image][:name]
      end

      if @image.update_attributes(system_image_params)
        render status: 200, json: @image.as_json(include: { created_by: { only: [:id, :username], methods: [:main_character] } })
      else
        render status: 500, json: {message: "System Image could not be created because: #{@image.errors.full_messages.to_sentence}"}
      end
    else
      render status: 404, json: { message: "System image not found" }
    end
  end

  # DELETE api/system-map/image/:image_id
  def delete_system_image
    begin
      @image = SystemMapImage.find_by_id(params[:image_id].to_i)
      if @image
        if @image.destroy
          render status: 200, json: { message: 'Image added'}
        else
          render status: 500, json: {message: "Error Occured: Image could not be deleted."}
        end
      else
        render status: 404, json: { message: "System image not found" }
      end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: Image could not be deleted: " + e.message }
    end
  end

  def make_system_image_default
    begin
      @image = SystemMapImage.new(system_image_params)
      if @image != nil

        #If its the system objects first image make it the default image
        #:of_system_id, :of_planet_id, :of_moon_id, :of_system_object_id, :of_location_id, :of_gravity_well_id
        if @image.of_system_id != nil && @image.of_system_id != 0
          @image.of_system.system_map_images.each do |image|
            image.is_default_image = false
            image.save
          end

        elsif @image.of_planet_id != nil && @image.of_planet_id != 0
          @image.of_planet_id.system_map_images.each do |image|
            image.is_default_image = false
            image.save
          end

        elsif @image.of_moon_id != nil && @image.of_moon_id != 0
          @image.of_moon_id.system_map_images.each do |image|
            image.is_default_image = false
            image.save
          end

        elsif @image.of_system_object_id != nil && @image.of_system_object_id != 0
          @image.of_planet_id.system_map_images.each do |image|
            image.of_planet_id = false
            image.save
          end

        elsif @image.of_location_id != nil && @image.of_location_id != 0
          @image.of_location_id.system_map_images.each do |image|
            image.is_default_image = false
            image.save
          end

        elsif @image.of_gravity_well_id != nil && @image.of_gravity_well_id != 0
          @image.of_gravity_well_id.system_map_images.each do |image|
            image.is_default_image = false
            image.save
          end
        end

        @image.is_default_image = true

        if @image.save
          render status: 200, json: { message: 'Image added'}
        else
          render status: 500, json: { message: "Error Occured: Image could not be saved." }
        end
      else
        render status: 500, json: { message: "Error Occured: Image could not be saved." }
      end
    rescue => e
      render status: 500, json: { message: "ERROR Occured: New image could not be saved: " + e.message}
    end
  end

  def update_atmo_comps
    saveCount = 0
    params[:atmo_compositions].each do |comp|
      if comp[:id] != nil
        # then we are updating
        @compo = SystemMapAtmoComposition.find_by_id(params[:comp_id].to_i)
        if @compo != nil
          @compo.atmo_gas_id = comp[:atmo_gas][:id]
          @compo.for_planet_id = comp[:for_planet_id]
          @compo.for_moon_id = comp[:for_moon_id]
          @compo.for_system_object_id = comp[:for_system_object_id]
          @compo.percentage = comp[:percentage]
          if @compo.save
            saveCount = saveCount + 1
          end
        else
          render status: 404, json: { message: "Atmo comp not found" }
          return
        end
      else
        #then we are creating
        if SystemMapAtmoComposition.create(
          atmo_gas_id: comp[:atmo_gas][:id],
          for_planet_id: comp[:for_planet_id],
          for_moon_id: comp[:for_moon_id],
          for_system_object_id: comp[:for_system_object_id],
          percentage: comp[:percentage]
        )
          saveCount = saveCount + 1
        end
      end
    end #end comps loop
    if params[:atmo_compositions].count == saveCount
      render status: 200, json: { message: "Composition created or updated!" }
    else
      render status: 500, json: { message: "Errors occured. Not all comps created or updated." }
    end
  end

  def delete_atmo_comp
    @compo = SystemMapAtmoComposition.find_by_id(params[:comp_id].to_i)
    if @compo != nil
      if @compo.destroy
        render status: 200, json: { message: "Atmo composition removed" }
      else
        render status: 500, json: { message: "ERROR: Could not delete atmo comp" }
      end
    else
      render status: 404, json: { message: "Atmo composition not found." }
    end
  end

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
  def fix_system_types (system_object, params)
    if system_object != nil && (params != nil && params[:system] != nil && params[:system][:planets_attributes] != nil)
      puts "Fixing system types for #{system_object.planets.count} planets."
      puts ""
      system_object.planets.each do |planet|
        planet.planet_types.destroy_all #remove old ones
        puts "Params contains #{params[:system][:planets_attributes].count} planets."
        params[:system][:planets_attributes].each do |iplanet|
          puts "#{iplanet[:id].to_i} to #{planet.id}"
          if iplanet[:id].to_i == planet.id || (iplanet[:id].to_i == nil || iplanet[:id].to_i == 0)
            #update planet attributes
            iplanet[:planet_types].each do |type|
              t = SystemMapSystemPlanetaryBodyType.find_by_id(type[:id].to_i)
              puts "Adding #{t.title} to planet #{planet.title}"
              planet.planet_types << t
            end

            #update moon type attributes
            planet.moons.each do |moon|
              moon.moon_types.destroy_all
              iplanet[:moons].each do |imoon|
                if imoon[:id].to_i == moon.id || (imoon[:id].to_i == nil || imoon[:id].to_i == 0)
                  imoon[:moon_types].each do |mtype|
                    moon.moon_types << SystemMapSystemPlanetaryBodyMoonType.find_by_id(mtype[:id].to_i)
                  end
                end
              end
            end
          end
        end
      end

      puts "Done fixing types"
      puts ""
      #
      return system_object
    else
      puts "Critcal value null cannot check planet types."
    end #can
  end

  private
  def fix_discovered_by system_object
    puts 'Fixing system discovered bys///'
    # go through gravity Wells
    system_object.gravity_wells.each do |gravity_well|
      gravity_well.discovered_by = current_user if gravity_well.discovered_by == nil
      puts "Fixed gravity_well added #{current_user.username}" if gravity_well.discovered_by == nil
    end

    # go through system objects
    system_object.system_objects.each do |system_system_object|
      system_system_object.discovered_by = current_user if system_system_object.discovered_by == nil
      puts "Fixed system_system_object added #{current_user.username}" if system_system_object.discovered_by == nil
    end

    # go through planets
    system_object.planets.each do |planet|
      planet.discovered_by = current_user if planet.discovered_by == nil
      puts "Fixed planet added #{current_user.username}" if planet.discovered_by == nil
      planet.system_objects.each do |planet_system_object|
        planet_system_object.discovered_by = current_user if planet_system_object.discovered_by == nil
        puts "Fixed planet_system_object added #{current_user.username}" if planet_system_object.discovered_by == nil
      end
      planet.moons.each do |planet_moon|
        planet_moon.discovered_by = current_user if planet_moon.discovered_by == nil
        puts "Fixed planet_moon added #{current_user.username}" if planet_moon.discovered_by == nil
        planet_moon.system_objects.each do |planet_moon_system_object|
          planet_moon_system_object.discovered_by = current_user if planet_moon_system_object.discovered_by == nil
          puts "Fixed planet_moon_system_object added #{current_user.username}" if planet_moon_system_object.discovered_by == nil
        end
      end
    end
    puts 'Done fixing discovered bys!'
    return system_object
  end

  private
  def system_create_params
    params.require(:system).permit(:id,
                                   :title,
                                   :description,
                                   system_objects_attributes: [:id,
                                                               :title,
                                                               :description,
                                                               :object_type_id],
                                   gravity_wells_attributes: [:id,
                                                              :title,
                                                              :description,
                                                              :luminosity_class_id,
                                                              :gravity_well_type_id],
                                   planets_attributes: [:id,
                                                        :title,
                                                        :description,
                                                        moons_attributes:[:id,
                                                                          :title,
                                                                          :description,
                                                                          moon_types: [:id],
                                                                          system_objects_attributes: [:id, :title, :description, :object_type_id],
                                                                          locations_attributes: [:id, :title, :description]
                                                                          ],
                                                        system_objects_attributes: [:id, :title, :description, :object_type_id],
                                                        planet_types_attributes: [:id],
                                                        locations_attributes: [:id, :title, :description]
                                                        ])
  end

  private
  def system_image_params
    params.require(:image).permit(:title, :description, :of_system_id, :of_planet_id, :of_moon_id, :of_system_object_id, :of_location_id, :of_gravity_well_id)
  end

  private
  def settlement_params
    params.require(:settlement).permit(:title, :description, :coordinates, :faction_affiliation_id, :on_planet_id, :on_moon_id)
  end

  private
  def location_params
    params.require(:location).permit(:title, :description, :coordinates, :faction_affiliation_id, :on_planet_id, :on_moon_id, :on_system_object_id, :on_settlement_id, :location_type_id)
  end

  private
  def moon_params
    params.require(:moon).permit(:title, :description, :orbits_planet_id)
  end

  private
  def system_object_params
    params.require(:system_object).permit(:title, :description, :object_type_id, :orbits_system_id, :orbits_planet_id, :orbits_moon_id)
  end
end
