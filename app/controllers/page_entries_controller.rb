class PageEntriesController < ApplicationController
  before_action :require_user
  before_action :require_member

  # index, list availabe to all members

  before_action only: [:create_page, :update_page, :delete_page, :publish, :unpublish, :add_role, :remove_role] do |a|
   a.require_one_role([29, 30]) #page editor
  end

  before_action only: [:create_category, :update_category, :delete_category] do |a|
   a.require_one_role([30]) #page admin
  end

  # GET api/pages
  def list
    @your_pages = Page.where('is_published = ? AND creator_id = ? AND archived = ?', false, current_user.id, false) if current_user.isinrole(29) || current_user.isinrole(30)
    @published_pages = []

    Page.where('is_published = ? AND archived = ?', true, false).each do |page|
      if page.page_entry_roles.count > 0
        page.page_entry_roles.each do |role|
          @published_pages << page if current_user.isinrole(role.id) || current_user.isinrole(30)
        end
      else
        @published_pages << page
      end
    end

    # make sure there are no double entries
    @published_pages.uniq!

    render status: 200, json: { published_pages: @published_pages.as_json(include: { roles:{}, page_category: {}, creator: { only:[], methods: [:main_character_full_name]}, page_entry_edits: { include: { user: { only:[], methods: [:main_character_full_name] } } } }), your_pages: @your_pages.as_json(include: { roles:{}, page_category: {} }), permissions: { isEditor: current_user.isinrole(29), isAdmin: current_user.isinrole(30) } }
  end

  # POST api/pages/
  def create_page
    @page = Page.new(title: 'New Page')
    @page.creator_id = current_user.id
    @page.archived = false
    @page.page_entry_edits << PageEntryEdit.new(user_id: current_user.id, comment: 'Page created')
    if @page.save
      render status: 200, json: { message: 'Page created', page: @page.as_json(include: { roles:{}, page_category: {}, creator: { only:[], methods: [:main_character_full_name]}, page_entry_edits: { include: { user: { only:[], methods: [:main_character_full_name] } } } }) }
    else
      render status: 500, json: { message: 'Error occured. Page could not be created' }
    end
  end

  # PATCH api/pages/
  def update_page
    @page = Page.find_by_id(params[:page_id].to_i)
    if @page != nil
      if (!@page.is_official || (@page.is_official && current_user.isinrole(30)))
        @page.page_entry_edits << PageEntryEdit.new(user_id: current_user.id, comment: 'Updated page content')
        if @page.update_attributes(page_params)
          render status: 200, json: { message: 'Page updated' }
        else
          render status: 500, json: { message: 'Error occured. Page could not be updated' }
        end
      else
        render status: 403, json: { message: 'You are not authorized to edit this page.' }
      end
    else
      render status: 404, json: { message: 'Page not found' }
    end
  end

  # DELETE api/pages/:page_id
  def delete_page
    @page = Page.find_by_id(params[:page_id].to_i)
    if @page != nil
      @page.page_entry_edits << PageEntryEdit.new(user_id: current_user.id, comment: 'Archived page')
      @page.archived = true
      if @page.save
        render status: 200, json: { message: 'Page updated' }
      else
        render status: 500, json: { message: 'Error occured. Page could not be updated' }
      end
    else
      render status: 404, json: { message: 'Page not found' }
    end
  end

  # POST api/pages/publish
  def publish
    @page = Page.find_by_id(params[:page_id].to_i)
    if @page != nil
      @page.page_entry_edits << PageEntryEdit.new(user_id: current_user.id, comment: 'Published page')
      @page.published_when = Time.now
      @page.is_published = true
      if @page.save
        render status: 200, json: { message: 'Page Published' }
      else
        render status: 500, json: { message: 'Error occured. Page could not be Published' }
      end
    else
      render status: 404, json: { message: 'Page not found' }
    end
  end

  # POST api/pages/unpublish
  def unpublish
    @page = Page.find_by_id(params[:page_id].to_i)
    if @page != nil
      @page.page_entry_edits << PageEntryEdit.new(user_id: current_user.id, comment: 'Un-published page')
      @page.published_when = nil
      @page.is_published = false
      if @page.save
        render status: 200, json: { message: 'Page Un-published' }
      else
        render status: 500, json: { message: 'Error occured. Page could not be Un-published' }
      end
    else
      render status: 404, json: { message: 'Page not found' }
    end
  end

  # POST api/pages/add-role
  # Body should contain: role_id, page_id
  def add_role
    @page = Page.find_by_id(params[:page_id].to_i)
    if @page != nil
      @role = Role.find_by_id(params[:role_id].to_i)
      if @role != nil
        @role_ref = PageEntryRole.where('role_id = ? AND page_id = ?', params[:role_id].to_i, params[:page_id].to_i)
        if @role_ref.count == 0
          @page.roles << @role
          if @page.save
            render status: 200, json: { message: 'Role added.', roles: @page.roles }
          else
            render status: 500, json: { message: 'Error occured. Role could not be added.' }
          end
        else
          render status: 403, json: { message: 'Role already added to page'}
        end
      else
        render status: 404, json: { message: 'Found page but could not find role'}
      end
    else
      render status: 404, json: { message: 'Page not found' }
    end
  end

  # POST api/pages/remove-role role_id page_id
  # Body should contain: role_id, page_id
  def remove_role
    @page = Page.find_by_id(params[:page_id].to_i)
    if @page != nil
      @role_ref = PageEntryRole.where('role_id = ? AND page_id = ?', params[:role_id].to_i, params[:page_id].to_i)
      if @role_ref.count == 1
        if @role_ref.destroy_all
          @page = Page.find_by_id(params[:page_id].to_i)
          render status: 200, json: { message: 'Role removed from page', roles: @page.roles  }
        else
          render status: 500, json: { message: 'Error Occured. Role could not removed from page' }
        end
      else
        if @role_ref.count == 0
          render status: 404, json: { message: 'The specified role was not assigned to this page.'}
        else
          render status: 500, json: { message: "Error occured. Role exists too many times. Check with admin to fix this issue"}
        end
      end
    else
      render status: 404, json: { message: 'Page not found' }
    end
  end

  # GET api/pages/category
  def fetch_categories
    @page_categories = PageCategory.all.order('title ASC')
    # @roles = Role.all.order('name ASC')

    # TODO: The roles controller should be responsible for fetching the roles
    # render status: 200, json: { page_categories: @page_categories, roles: @roles }
    render status: 200, json: @page_categories
  end

  # POST 'api/pages/category'
  def create_category
    # @page_category =
    if PageCategory.create(category_params)
      render status: 200, json: { message: 'Page category created' }
    else
      render status: 500, json: { message: 'Error Occured. Page category could not be created' }
    end
  end

  # PATCH api/pages/category
  def update_category
    @page_category = PageCategory.find_by_id(params[:page][:id].to_i)
    if @page_category != nil
      puts "Page category not nil"
      if @page_category.update_attributes(category_params)
        render status: 200, json: { message: 'Page category updated' }
      else
        render status: 500, json: { message: 'Error Occured. Page category could not be updated' }
      end
    else
      render status: 404, json: { message: 'Page category not found' }
    end

  end

  # DELETE api/pages/category/:page_category_id
  def delete_category
    @page_category = PageCategory.find_by_id(params[:page_category_id].to_i)
    if @page_category != nil
      @page_category.pages.each do |page|
        page.page_category_id = nil
        page.save
      end
      if @page_category.destroy
        render status: 200, json: { message: 'Page category deleted' }
      else
        render status: 500, json: { message: 'Error Occured. Page category could not be deleted' }
      end
    else
      render status: 404, json: { message: 'Page category not found' }
    end
  end

  private
  def page_params
    params.require(:page).permit(:title, :content, :page_category_id, :tags, :is_official)
  end

  private
  def page_update_params
    params.require(:page).permit(:id, :title, :content, :page_category_id, :tags, :is_official)
  end

  private
  def category_params
    params.require(:category).permit(:title)
  end

  private
  def category_update_params
    params.require(:category).permit(:id, :title)
  end
end
