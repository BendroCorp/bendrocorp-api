class FieldsController < ApplicationController
  before_action :require_user
  before_action :require_member

  def list
    render json: Field.all.as_json(include: { descriptors: { } })  
  end
end
