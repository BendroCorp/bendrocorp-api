class MenuItemsController < ApplicationController
  before_action :require_user
  before_action :require_member, except: [:list]

  before_action only: [:create, :update, :delete, :add_role, :delete_role] do |a|
    a.require_one_role([34]) # menu editor
  end

  # GET api/menu
  # Fetch the menu
  def list
    # menu item return var
    @menu_items = []

    # Loop through
    MenuItem.where(archived: false).order('ordinal').each do |menu_item| # where('nested_under_id is NULL')
      # are protected by role
      if menu_item.roles.count > 0
        menu_item.roles.each do |role|
          # add an * to show it is protected by role (that is not member, client, applicant)
          # we only want to show special protected menu items with the *
          menu_item.title = role.id < 1 ? menu_item.title : "#{menu_item.title} *"
          @menu_items << menu_item if current_user.isinrole(role.id)
        end
      # if they are not protected by roles
      else
        @menu_items << menu_item
      end
    end
    # Hand out the member items
    render status: 200, json: @menu_items #.as_json(include: { nested_items: { } })
  end

  # POST api/menu
  def create
    @menu_item = MenuItem.new(menu_item_params)
    if @menu_item.save
      render status: 201, json: @menu_item
    else
      render status: 500, json: { message: "Menu item could not be created because: #{@menu_item.errors.full_messages.to_sentence}" }
    end
  end

  # PATCH api/menu
  def update
    @menu_item = MenuItem.find_by_id(params[:menu_item][:id])
    if @menu_item.update_attributes(menu_item_params)
      render status: 200, json: @menu_item
    else
      render status: 500, json: { message: "Menu item could not be updated because: #{@menu_item.errors.full_messages.to_sentence}" }
    end
  end

  # DELETE api/menu/:menu_item_id
  def delete
    @menu_item = MenuItem.find_by_id(params[:menu_item_id])
    if @menu_item.destroy
      render status: 200, json: { message: 'Menu item removed successfully!' }
    else
      render status: 500, json: { message: "Menu item could not be deleted because: #{@menu_item.errors.full_messages.to_sentence}" }
    end
  end

  def menu_item_params
    params.require(:menu_item).permit(:title, :icon, :link, :internal, :nested_under_id, :ordinal)
  end
end
