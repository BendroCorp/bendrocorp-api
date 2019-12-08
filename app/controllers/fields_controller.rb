class FieldsController < ApplicationController
  before_action :require_user
  before_action :require_member

  # GET api/fields
  def list
    render json: Field.all.as_json(include: { descriptors: { } })
  end

  # GET api/fields/:id
  def show
    render json: FieldDescriptor.where(field_id: params[:id]).order('ordinal')
  end
end
