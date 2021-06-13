class FlightLogsController < ApplicationController
  before_action :require_user
  before_action :require_member

  # GET api/flight-logs
  def list
    # @owned_ships = []
    # #owned_ids = []
    # #@owned_ships = current_user.main_character.owned_ships
    # all_owned_ships = OwnedShip.all
    #
    # # we need all ships where the current user owns them or is in the crew
    # all_owned_ships.each do |ship|
    #   #@owned_ships << ship if ship.character ==
    #   if ship.character.id == current_user.main_character.id
    #     @owned_ships << ship
    #   elsif ship.user_in_crew current_user && ship.character.id != current_user.main_character.id
    #     ship.title = "#{ship.title} (Crew)"
    #     @owned_ships << ship
    #   end
    # end

    # get flight logs
    #@owned_ships.each do |owned_ship|
    #  owned_ids << owned_ship.id
    #end
    # owned_ship_id in (?) OR owned_ids,

    @flight_logs = FlightLog.where(log_owner_id: current_user.main_character.id).where(archived: false).order("created_at desc")

    render status: 200, json: @flight_logs.as_json(methods: [:log_time_ms, :full_location, :log_title], include: { image_uploads: { methods: [:image_url_thumbnail, :image_url_original] }, owned_ship: { include: { character: { methods: :full_name}, ship: {}}, methods: :full_ship_title }, system: { include: { planets: { include: { moons: {}} } }}, planet: {}})

  end

  # GET api/flight-logs/ships
  # Get all of the ships that the user is allowed to create a flight log for
  def list_ships
    @owned_ships = []

    all_owned_ships = OwnedShip.where(hidden: false)

    # we need all ships where the current user owns them or is in the crew
    all_owned_ships.each do |ship|
      #@owned_ships << ship if ship.character ==
      if ship.character.id == current_user.main_character.id
        @owned_ships << ship
      elsif ship.user_in_crew current_user && ship.character.id != current_user.main_character.id
        ship.title = "#{ship.title} (Crew)"
        @owned_ships << ship
      end
    end

    render status: 200, json: @owned_ships
  end

  # GET api/flight-logs/:flight_log_id
  def show
    @log = FlightLog.find_by_id(params[:flight_log_id])
    if @log && @log.log_owner = current_user.main_character
      render status: 200, json: @log.as_json(methods: [:log_time_ms, :full_location, :log_title], include: { image_uploads: { methods: [:image_url_thumbnail, :image_url_original] }, owned_ship: { include: { character: { methods: :full_name}, ship: {}}, methods: :full_ship_title }, system: { include: { planets: { include: { moons: {}} } }}, planet: {}})
    else
      render status: 404, json: { message: 'Flight log not found or you do not have accesss to it!' }
    end
  end

  # POST api/flight-logs
  # Body should contain flight log object
  def create
    puts "New Flight Log #{flight_log_params.inspect}"
    @log = FlightLog.new(flight_log_params)
    can = can_create_log(@log.owned_ship_id)
    if (@log.owned_ship_id != nil && can) || @log.owned_ship_id == nil
      @log.log_owner = current_user.main_character #goes to the character not the user...since the character can die :'(
      if @log.save
        puts "New log id: #{@log.id} "
        if params["new_image_uploads"].to_a.count > 0
          params["new_image_uploads"].to_a.each do |image|
            # img = ImageUpload.create(image: "data:#{image[:image][:filetype]};base64,#{image[:image][:base64]}", image_file_name: image[:image][:filename], title: image[:title], description: image[:description], uploaded_by_id: current_user.id)
            # @log.image_uploads << img
            # @log.save
            @log.image_uploads << attach_image(image)
          end
        end
        render status: 200, json: @log
      else
        render status: 500, json: { message: "Flight log could not be created because #{@log.errors.full_messages.to_sentence}!"}
      end
    else
      render status: 403, json: { message: 'You are not authorized to create a flight log for this ship.' }
    end
  end

  # PATCH api/flight-logs
  # Body should contain flight log object
  def update
    @log = FlightLog.find_by_id(params[:flight_log][:id].to_i)
    if @log != nil
      if (@log.owned_ship_id != nil && can_create_log(@log.owned_ship_id)) || @log.owned_ship_id == nil
        if @log.update_attributes(flight_log_params)
          if params["new_image_uploads"].to_a.count > 0
            params["new_image_uploads"].to_a.each do |image|
              # img = ImageUpload.create(image: "data:#{image[:image][:filetype]};base64,#{image[:image][:base64]}", image_file_name: image[:image][:filename], title: image[:title], description: image[:description], uploaded_by_id: current_user.id)
              # @log.image_uploads << img
              # @log.save
              @log.image_uploads << attach_image(image)
            end
          end
          render status: 200, json: @log
        else
          render status: 500, json: { message: 'Flight log could not be updated.'}
        end
      else
        render status: 403, json: { message: 'You are not authorized to update a flight log for this ship.' }
      end
    else
      render status: 500, json: { message: 'Flight log not found.'}
    end
  end

  # DELETE api/flight-logs/:flight_log_id
  # Body should contain flight_log_id
  def delete
    @log = FlightLog.find_by_id(params[:flight_log_id].to_i)
    if @log != nil
      if (@log.owned_ship_id != nil && can_create_log(@log.owned_ship_id)) || @log.owned_ship_id == nil
        @log.archived = true
        if @log.save
          render status: 200, json: { message: 'Flight log archived!' }
        else
          render status: 500, json: { message: 'Flight log could not be removed.' }
        end
      else
        render status: 403, json: { message: 'You are not authorized to delete a flight log for this ship.' }
      end
    else
      render status: 404, json: { message: 'Flight log not found.' }
    end
  end

  private

  def attach_image image_data
    data = image_data[:image][:base64].split(',')[1]

    # create and perform a base resize on the image
    image = MiniMagick::Image.read(StringIO.new(Base64.decode64(data)))
    pipeline = ImageProcessing::MiniMagick.source(image)
    resized_image = pipeline.convert('png').resize_to_fit!(1920, 1080)
    # resized_image = MiniMagick::Image.read(StringIO.new(Base64.decode64(data)))
    # resized_image = resized_image.resize "1920x1080>"
    # resized_image = resized_image.format "png"

    # transform the data into the ActiveStorage blob
    image_blob = ActiveStorage::Blob.create_after_upload!(
      io: File.open(resized_image.path), #resized_image.path
      filename: "#{@star_object.id}.png",
      content_type: 'image/png'
    )

    upload = ImageUpload.create(title: image[:title], description: image[:description], uploaded_by_id: current_user.id, image: image_blob)

    # ImageSizerJob.perform_later(upload, 'image', { resize: '100x100^', quality: '100%', gravity: 'center' })
    # ImageSizerJob.perform_later(upload, 'image', { resize: '25x25^', quality: '100%', gravity: 'center' })
    ImageSizerJob.perform_later(upload, 'image', { resize_to_fill: [100, 100] })
    ImageSizerJob.perform_later(upload, 'image', { resize_to_fill: [25, 25] })

    # return the result
    upload
  end

  def can_create_log owned_ship_id
    @owned_ships = []

    all_owned_ships = OwnedShip.all

    # we need all ships where the current user owns them or is in the crew
    all_owned_ships.each do |ship|
      #@owned_ships << ship if ship.character ==
      # get the main character id
      main_character_id = current_user.main_character.id
      # check it
      if ship.character.id == main_character_id
        @owned_ships << ship
      elsif ship.user_in_crew current_user && ship.character.id != main_character_id
        ship.title = "#{ship.title} (Crew)"
        @owned_ships << ship
      end
    end

    ret = false
    @owned_ships.each do |owned_ship|
      ret = true if owned_ship.id == owned_ship_id
    end

    ret
  end

  private
  def flight_log_params
    params.require(:flight_log).permit(:title, :text, :owned_ship_id, :ship_id, :system_id, :planet_id, :moon_id)
  end

end
