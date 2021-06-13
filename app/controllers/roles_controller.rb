class RolesController < ApplicationController
  before_action :require_user
  before_action :require_member

  before_action except: [:list] do |a|
   a.require_one_role([37]) # role admin
  end

  # GET api/role/simple
  def list_simple
    render status: 200, json: Role.where('id > 0').order('id')
  end

  # GET api/role
  def list
    if current_user.isinrole(37)
      render status: 200, json: Role.where('id > 0').order('id').as_json(methods: [:role_users], include: { nested_roles: { include: { role_nested: { } } }, classification_levels: { } } )
    else
      render status: 200, json: Role.where('id > 0').order('id')
    end
  end

  # DEPRECATED
  # GET api/role/admin
  def admin_fetch_roles
    render status: 200, json: Role.where('id > 0').order('id').as_json(methods: [:role_users], include: { nested_roles: { include: { role_nested: { } } }, classification_levels: { } } )
  end

  # POST api/role
  def create_role
    if Role.create(role_params)
      render status: 200, json: { message: 'Role created.' }
    else
      render status: 500, json: { message: 'Error Occured. Role could not be created.' }
    end
  end

  # PATCH api/role
  def update_role
    @role = Role.find_by_id(params[:role][:id].to_i)
    if @role != nil
      if @role.update(role_params)
        render status: 200, json: { message: 'Role updated.' }
      else
        render status: 500, json: { message: 'Error Occured. Role could not be updated.' }
      end
    else
      render status: 404, json: { message: 'Role not found. It maybe have been removed.' }
    end
  end

  # POST api/role/nest
  def create_nested_role
    @nested_role = NestedRole.create(nested_role_params)
    if @nested_role.save
      render status: 200, json: @nested_role.as_json(include: { role_nested: { } })
    else
      render status: 500, json: { message: "Nested role could not be created because: #{@nested_role.errors.full_messages.to_sentence}" }
    end
  end

  # DELETE api/role/nest/:nested_role_id
  def delete_nested_role
    @nr = NestedRole.find_by_id(params[:nested_role_id].to_i)
    if @nr != nil
      if @nr.destroy
        render status: 200, json: { message: 'Nested role deleted.' }
      else
        render status: 500, json: { message: 'Error Occured. Nested role could not be deleted.' }
      end
    else
      render status: 404, json: { message: 'Nested role not found. It may have been removed.' }
    end
  end

  private
  def role_params
    params.require(:role).permit(:id, :name, :description)
  end

  private
  def nested_role_params
    params.require(:nested_role).permit(:role_id, :role_nested_id)
  end
end
