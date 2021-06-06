class StarObjectController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action :set_star_object, only: [:show, :update, :archive]

  # system map editor or admin
  before_action only: [:create, :update] do |a|
    a.require_one_role([22, 23])
  end

  # system map admin only
  before_action only: [:archive] do |a|
    a.require_one_role([23])
  end

  # GET /api/system-map/object
  def list
    # fetch the results
    fetched = SystemMapStarObject.where(archived: false, draft: false) unless current_user.is_in_one_role([22, 23])
    fetched ||= SystemMapStarObject.where(archived: false) if current_user.is_in_one_role([22, 23])

    # return the results
    render json: fetched.to_json(include: { object_type: {} }, methods: [:kind, :title_with_kind, :primary_image_url, :primary_image_url_full])
  end

  # GET /api/system-map/object/search/:uuid_segment
  def id_search
    if params[:uuid_segment] && params[:uuid_segment].match(/^(?!.*--)[A-Za-z0-9_-]*$/)
      @star_object = SystemMapStarObject.where("id::text LIKE ? AND archived = false", "#{params[:uuid_segment]}%")

      # return the pages
      # render json: @star_object.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only:[:id], methods: [:main_character] } } }, parent: { methods: [:kind, :primary_image_url] }, children: { methods: [:kind, :primary_image_url] }, object_type: {} }, methods: [:kind, :primary_image_url, :primary_image_url_full, :fields, :field_values])
      render json: @star_object.to_json(include: { master: { include: { type: { include: { fields: { methods: [:descriptors] } }} } }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only:[:id], methods: [:main_character] } } }, parent: { methods: [:kind, :primary_image_url] }, children: { methods: [:kind, :primary_image_url] }, object_type: {} }, methods: [:kind, :title_with_kind, :primary_image_url, :primary_image_url_full, :fields, :field_values])
    else
      render status: 400, json: { message: 'Invalid ID segment!' }
    end
  end

  # GET /api/system-map/rules
  def list_rules
    render json: SystemMapMappingRule.all
  end

  # GET /api/system-map/object/:id
  def show
    if @star_object
      if !@star_object.draft || current_user.is_in_one_role([22, 23])
        # render json: @star_object.to_json(include: { system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only:[:id], methods: [:main_character] } } }, parent: { methods: [:kind, :primary_image_url] }, children: { methods: [:kind, :primary_image_url] }, object_type: {} }, methods: [:kind, :primary_image_url, :primary_image_url_full, :fields, :field_values])
        render json: @star_object.to_json(include: { master: { include: { type: { include: { fields: { methods: [:descriptors] } }} } }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only:[:id], methods: [:main_character] } } }, parent: { methods: [:kind, :primary_image_url] }, children: { methods: [:kind, :primary_image_url] }, object_type: {} }, methods: [:kind, :title_with_kind, :primary_image_url, :primary_image_url_full, :fields, :field_values])
        return
      end
    end

    render status: 404, json: { message: 'System map object not found!' }
  end

  # POST /api/system-map/object
  def create
    # create the initial object from the params
    @star_object = SystemMapStarObject.create(system_map_star_objects_params)

    # primary image
    if params[:star_object][:new_primary_image]
      # get the image data
      data = params[:star_object][:new_primary_image][:base64].split(',')[1]

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

      # check to see if this object lacks a primary image
      if !@star_object.primary_image.nil?
        # attach the new image blob
        @star_object.primary_image.image.attach(image_blob)
      else # if this star object never had a primary image
        # create a new image and attach the blob
        @star_object.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: image_blob, title: @star_object.title, description: @star_object.title)
      end
    end

    # if !params[:star_object][:new_primary_image].nil?
    #   if !@star_object.primary_image.nil?
    #     @star_object.primary_image.title = params[:star_object][:title]
    #     @star_object.primary_image.image = params[:star_object][:new_primary_image][:base64]
    #     @star_object.primary_image.image_file_name = params[:star_object][:new_primary_image][:name]
    #   else
    #     @star_object.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: params[:star_object][:new_primary_image][:base64], image_file_name: params[:star_object][:new_primary_image][:name], title: @star_object.title, description: @star_object.title)
    #   end
    # end

    if @star_object.save
      # if we updated the image then run a background job to create images variants
      if params[:star_object][:new_primary_image]
        ImageSizerJob.perform_later(@star_object.primary_image, 'image', { resize: '100x100^', quality: '100%', gravity: 'center' })
        ImageSizerJob.perform_later(@star_object.primary_image, 'image', { resize: '200x200^', quality: '100%', gravity: 'center' })
      end

      render json: @star_object.to_json(include: { master: { include: { type: { include: { fields: { methods: [:descriptors] } }} } }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only:[:id], methods: [:main_character] } } }, parent: { methods: [:kind, :primary_image_url] }, children: { methods: [:kind, :primary_image_url] }, object_type: {} }, methods: [:kind, :title_with_kind, :primary_image_url, :primary_image_url_full, :fields, :field_values])
    else
      render json: { message: @star_object.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  # PUT /api/system-map/object
  def update
    # make sure the object was found/exists
    if @star_object
      # primary image
      # primary image
    if params[:star_object][:new_primary_image]
      # get the image data
      data = params[:star_object][:new_primary_image][:base64].split(',')[1]

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

      # check to see if this object lacks a primary image
      if !@star_object.primary_image.nil?
        # attach the new image blob
        @star_object.primary_image.image.attach(image_blob)
      else # if this star object never had a primary image
        # create a new image and attach the blob
        @star_object.primary_image = SystemMapImage.create(created_by_id: current_user.id, image: image_blob, title: @star_object.title, description: @star_object.title)
      end
    end

      # update the object
      if @star_object.update(system_map_star_objects_params)
        # if we updated the image then run a background job to create images variants
        if params[:star_object][:new_primary_image]
          ImageSizerJob.perform_later(@star_object.primary_image, 'image', { resize: '100x100^', quality: '100%', gravity: 'center' })
          ImageSizerJob.perform_later(@star_object.primary_image, 'image', { resize: '200x200^', quality: '100%', gravity: 'center' })
        end

        render json: @star_object.to_json(include: { master: { include: { type: { include: { fields: { methods: [:descriptors] } }} } }, system_map_images: { methods: [:image_url_thumbnail, :image_url], include: { created_by: { only:[:id], methods: [:main_character] } } }, parent: { methods: [:kind, :primary_image_url] }, children: { methods: [:kind, :primary_image_url] }, object_type: {} }, methods: [:kind, :title_with_kind, :primary_image_url, :primary_image_url_full, :fields, :field_values])
      else
        render json: { message: @star_object.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'System map object not found!' }
    end
  end

  # DELETE /api/system-map/object/:id
  def archive
    # check to make sure the object exists
    if @star_object
      # set the archived flag
      @star_object.archived = true

      # save the results
      if @star_object.save
        render json: { message: 'Star object archived!' }
      else
        render json: { message: @star_object.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    else
      render status: 404, json: { message: 'System map object not found!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_star_object
      # try to find the object
      @star_object = SystemMapStarObject.find(params[:star_object][:id]) if params[:star_object]
      @star_object ||= SystemMapStarObject.find(params[:id])

      # return the object as long as its not archived
      @star_object unless @star_object.archived
    end

    # Only allow a trusted parameter "white list" through.
    def system_map_star_objects_params
      params.require(:star_object).permit(:title, :description, :tags, :parent_id, :object_type_id)
    end

    # once place to adjust what json details we return for a multi object fetch
    # def star_object_json star_object
    #   star_object.to_json(include: { object_type: {} }, methods: [:kind, :primary_image_url, :primary_image_url_full])
    # end

    # once place to adjust what json details we return for a single object fetch
    # def star_object_details_json star_object
    #   star_object.to_json(include: { parent: {}, children: {}, object_type: {} }, methods: [:kind, :primary_image_url, :primary_image_url_full])
    # end
end
