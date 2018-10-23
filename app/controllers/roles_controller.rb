class RolesController < ApplicationController
  before_action :require_user
  before_action :require_member

  # index, list availabe to all members

  before_action except: [:list] do |a|
   a.require_one_role([9]) # CEO only
 end

   # A role is an ID, title, Description
   # Nested role is ID, role_id (the role) role_nested_id (the role you are nesting in the role)
   # Example role_id (CEO-9) to (Executive-2)

  # GET api/role
  def list
    render status: 200, json: Role.all
  end

  # GET api/role/admin
  def admin_fetch_roles
    render status: 200, json: Role.all.as_json(methods: [:role_users], include: { nested_roles: { include: { role_nested: { } } }, classification_levels: { } } )
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
      if @role.update_attributes(role_params)
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
    if NestedRole.create(nested_role_params)
      render status: 200, json: { message: 'Nested role created.' }
    else
      render status: 500, json: { message: 'Error Occured. Nested role could not be created.' }
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
