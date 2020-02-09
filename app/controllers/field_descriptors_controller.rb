class FieldDescriptorsController < ApplicationController
  before_action :require_user
  before_action :require_member

  before_action except: [] do |a|
    a.require_one_role([52]) # field admin
  end

  before_action :set_field_descriptor, only: [:update, :archive]

  def create
    @field_descriptor = FieldDescriptor.new(field_descriptor_params)
    if !@field_descriptor.field.from_class
      if !@field_descriptor.field.read_only
        # creator
        @field_descriptor.created_by_id = current_user.id

        if @field_descriptor.save
          render status: :created, json: @field_descriptor
        else
          render status: 500, json: { message: "Could not create new field descriptor because: #{@field_descriptor.errors.full_messages.to_sentence}." }
        end
      else
        render status: 400, json: { message: 'Cannot add descriptor to read-only field!' }
      end
    else
      render status: 400, json: { message: 'You cannot add a descriptor to a class-based field.' }
    end
  end

  def update
    if @field_descriptor
      if !@field_descriptor.read_only && !@field_descriptor.field.read_only
        if @field_descriptor.update(field_descriptor_params)
          render json: @field_descriptor
        else
          render status: 500, json: { message: "Could not update new field descriptor because: #{@field_descriptor.errors.full_messages.to_sentence}." }
        end
      else
        render status: 400, json: { message: 'This descriptor is marked read-only and cannot be edited!' }
      end
    else
      render status: 404, json: { message: 'Field descriptor not found!' }
    end
  end

  def archive
    if @field_descriptor
      @field_descriptor.archived = true
      if @field_descriptor.save
        render json: { message: 'Descriptor archived!' }
      else
        render status: 500, json: { message: "Could not update new field descriptor because: #{@field_descriptor.errors.full_messages.to_sentence}." }
      end
    else
      render status: 404, json: { message: 'Field descriptor not found!' }
    end
  end

  private
    def set_field_descriptor
      @field_descriptor = FieldDescriptor.find(params[:descriptor][:id]) if params[:descriptor]
      @field_descriptor ||= FieldDescriptor.find(params[:id])
    end
    
    def field_descriptor_params
      params.require(:descriptor).permit(:title, :description, :ordinal, :field_id)
    end
end
