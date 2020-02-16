class FieldsController < ApplicationController
  before_action :set_field, only: [:update, :archive]
  before_action :require_user
  before_action :require_member

  before_action except: [:list, :show, :show_details] do |a|
    a.require_one_role([52]) # field admin
  end

  # GET api/fields
  def list
    render json: Field.all.as_json(include: { field_descriptor_class: {} }, methods: [:from_class, :descriptors])
  end

  # GET api/fields/:id
  def show
    @field = Field.where(id: params[:id], archived: false).first

    if @field
      render json: @field.descriptors
    else
      render status: :not_found, json: { message: 'Field not found!' }
    end
  end

  # GET api/fields/:id/details
  def show_details
    @field = Field.where(id: params[:id], archived: false).first

    if @field
      render json: @field.as_json(include: { field_descriptor_class: {} }, methods: [:from_class, :descriptors])
    else
      render status: :not_found, json: { message: 'Field not found!' }
    end
  end

  # POST api/fields/
  def create
    @field = Field.new(field_params)

    # add the creator
    @field.created_by_id = current_user.id

    # save back the new field
    if @field.save
      render json: @field.as_json(include: { field_descriptor_class: {} }, methods: [:from_class, :descriptors]), status: :created
    else
      render status: 500, json: { message: "Field could not be created because: #{@field.errors.full_messages.to_sentence}" }
    end
  end

  # PUT api/fields/
  def update
    if @field
      if !@field.read_only
        if @field.update(field_params)
          render status: 200, json: @field.as_json(include: { field_descriptor_class: {} }, methods: [:from_class, :descriptors])
        else
          render status: 500, json: { message: "Field could not be updated because: #{@field.errors.full_messages.to_sentence}" }
        end
      else
        render status: 400, json: { message: 'Field is read-only and cannot be edited!' }
      end
    else
      render status: 404, json: { message: 'Field not found!' }
    end
  end

  # DELETE api/fields/:id
  def archive
    if @field
      if !@field.read_only
        @field.archived = true
        if @field.save
          render status: 200, json: { message: 'Field archived!' }
        else
          render status: 500, json: { message: "Field could not be archived because: #{@field.errors.full_messages.to_sentence}" }
        end
      else
        render status: 400, json: { message: 'Field is read-only and cannot be edited!' }
      end
    else
      render status: 404, json: { message: 'Field not found!' }
    end
  end

  # GET api/fields/classes
  def field_classes
    render json: FieldDescriptorClass.where(archived: false)
  end

  private
    def set_field
      @field = Field.find(params[:field][:id])
      @field ||= Field.find(params[:id])
    end
    
    def field_params
      params.require(:field).permit(:name, :field_descriptor_class_id)
    end
end
