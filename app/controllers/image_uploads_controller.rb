class ImageUploadsController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action :set_image_upload, only: [:update, :destroy]

  # GET /images
  # def index
  #   @image_uploads = ImageUpload.all

  #   render json: @image_uploads
  # end

  # # POST /images
  # def create
  #   @image_upload = ImageUpload.new(title: 'Upload', uploaded_by_id: current_user.id, image: params[:image])

  #   if @image_upload.save
  #     if ENV['RAILS_ENV'] == 'production'
  #       render json: { path: @image_upload.image_url }, status: :created
  #     else
  #       render status: 200
  #     end
  #   else
  #     render json: { errors: @image_upload.errors }, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /images/:id
  # def destroy
  #   @image_upload.destroy
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_image_upload
  #     @image_upload = ImageUpload.find(params[:id])
  #   end

  #   # Only allow a trusted parameter "white list" through.
  #   def image_upload_params
  #     params.fetch(:image_upload, {})
  #   end
end
