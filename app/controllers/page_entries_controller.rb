class PageEntriesController < ApplicationController
  before_action :require_user
  before_action :require_member

  # index, list availabe to all members

  before_action only: [:create_page, :update_page, :delete_page, :publish, :unpublish, :add_role, :remove_role] do |a|
   a.require_one_role([29, 30]) # page editor
  end

  before_action only: [:create_category, :update_category, :delete_category] do |a|
   a.require_one_role([30]) # page admin
  end

  # GET api/pages
  def list
    @your_pages = Page.where('published = ? AND creator_id = ? AND archived = ?', false, current_user.id, false) if current_user.isinrole(29) || current_user.isinrole(30)
    @published_pages = []

    Page.where('published = ? AND archived = ?', true, false).each do |page|
      if page.page_entry_roles.count > 0
        page.page_entry_roles.each do |role|
          @published_pages << page if current_user.isinrole(role.id) || current_user.isinrole(30)
        end
      else
        @published_pages << page
      end
    end

    # combine your pages with published pages
    @published_pages.concat(@your_pages) if @your_pages && @your_pages.count > 0

    # make sure there are no double entries
    @published_pages.uniq!

    render status: 200, json: @published_pages.as_json(include: { categories: {}, roles: {}, creator: { only: [:id], methods: [:main_character_full_name]}, page_entry_edits: { include: { user: { only:[], methods: [:main_character_full_name] } } } })
  end

  # GET api/pages/:uuid
  def show
    @page = Page.find_by_id(params[:page_id])
    if @page && (@page.published == true || (current_user.isinrole(30) || @page.creator_id == current_user.id))
      render json: @page.as_json(include: { categories: {}, roles: {}, creator: { only: [:id], methods: [:main_character_full_name]}, page_entry_edits: { include: { user: { only:[], methods: [:main_character_full_name] } } } })
    else
      render status: :not_found, json: { message: 'Page not found!' }
    end
  end

  # get api/pages/search/:uuid_segment
  def id_search
    if params[:uuid_segment] && params[:uuid_segment].match(/^(?!.*--)[A-Za-z0-9_-]*$/)
      @pages = Page.where("id::text LIKE ? OR content::text LIKE ?", "#{params[:uuid_segment]}%", "#{params[:uuid_segment]}%")
      @pages = @pages.map { |page| page if page.published == true || (current_user.isinrole(30) || page.creator_id == current_user.id) }

      # return the pages
      render json: @pages.as_json(include: { categories: {}, roles: {}, creator: { only: [:id], methods: [:main_character_full_name]}, page_entry_edits: { include: { user: { only:[], methods: [:main_character_full_name] } } } })
    else
      render status: 400, json: { message: 'Invalid ID segment!' }
    end
  end

  # POST api/pages/
  def create_page
    @page = Page.new(title: 'New Page')
    @page.creator_id = current_user.id
    @page.archived = false
    @page.page_entry_edits << PageEntryEdit.new(user_id: current_user.id, comment: 'Page created')
    if @page.save
      render status: 200, json: @page.as_json(include: { categories: {}, roles: {}, creator: { only: [:id], methods: [:main_character_full_name]}, page_entry_edits: { include: { user: { only:[], methods: [:main_character_full_name] } } } })
    else
      render status: 500, json: { message: "Page could not be created because: #{@page.errors.full_messages.to_sentence}" }
    end
  end

  # PATCH|PUT api/pages/
  def update_page
    @page = Page.find_by_id(params[:page][:id])
    if @page != nil
      if (!@page.is_official || (@page.is_official && current_user.isinrole(30)))
        @page.page_entry_edits << PageEntryEdit.new(user_id: current_user.id, comment: 'Updated page content')

        # update the categories
        if params[:page][:categories]
          original_categories = @page.categories.map { |item| item.id }
          updated_categories = params[:page][:categories].map { |item| item[:id] }

          # remove old categories
          @page.page_in_categories.where(category_id: (original_categories - updated_categories)).delete_all

          # add infraction items
          (updated_categories - original_categories).each do |add_category_id|
            found_category = FieldDescriptor.find_by_id(add_category_id)
            @page.page_in_categories << PageInCategory.new(category_id: found_category.id) if found_category
            # PageInCategory.create(category_id: found_category, page_id: @page.id) if found_category
          end
        end

        # if the page has never been published before mark it published
        if params[:page][:published] == true && @page.published_when.nil?
          @page.published_when = Time.now
        end

        if @page.update(page_params)
          refetch = Page.find_by_id(@page.id)
          render status: 200, json: refetch.as_json(include: { categories: {}, roles: {}, creator: { only: [:id], methods: [:main_character_full_name]}, page_entry_edits: { include: { user: { only:[], methods: [:main_character_full_name] } } } })
        else
          render status: 500, json: { message: "Page could not be updated because: #{@page.errors.full_messages.to_sentence}" }
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
    @page = Page.find_by_id(params[:page_id])
    if !@page.nil?
      @page.page_entry_edits << PageEntryEdit.new(user_id: current_user.id, comment: 'Archived page')
      @page.archived = true
      if @page.save
        render status: 200, json: { message: 'Page archived!' }
      else
        render status: 500, json: { message: "Page could not be archived because: #{@page.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Page not found' }
    end
  end

  # POST api/pages/publish
  def publish
    @page = Page.find_by_id(params[:page][:id])
    if @page != nil
      @page.page_entry_edits << PageEntryEdit.new(user_id: current_user.id, comment: 'Published page')
      @page.published_when = Time.now
      @page.published = true
      if @page.save
        render status: 200, json: { message: 'Page Published' }
      else
        render status: 500, json: { message: "Page could not be published because: #{@page.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Page not found' }
    end
  end

  # POST api/pages/unpublish
  def unpublish
    @page = Page.find_by_id(params[:page][:id])
    if @page != nil
      @page.page_entry_edits << PageEntryEdit.new(user_id: current_user.id, comment: 'Un-published page')
      @page.published_when = nil
      @page.published = false
      if @page.save
        render status: 200, json: { message: 'Page Un-published' }
      else
        render status: 500, json: { message: "Page could not be unpublished because: #{@page.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Page not found' }
    end
  end

  # POST api/pages/add-role
  # Body should contain: role_id, page_id
  def add_role
    @page = Page.find_by_id(params[:page_id])
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
    @page = Page.find_by_id(params[:page_id])
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

  # GET 'api/pages/:page_id/images'
  def create_image
    # image_upload = ImageUpload.create(title: 'Upload', uploaded_by_id: current_user.id, image: params[:image])

    # page_image = PageImage.create(page_id: params[:page_id], image_upload_id: image_upload.id)

    # if page_image.save
    #   if ENV['RAILS_ENV'] == 'production'
    #     render json: { path: image_upload.image_url }, status: :created
    #   else
    #     render status: 200
    #   end
    # else
    #   render status: 400, json: { message: "Page could not be updated because: #{@page.errors.full_messages.to_sentence}" }
    # end
  end

  # DELETE api/pages/:page_id/images
  def delete_image
    # TODO: Not sure if this will actually be used or not
    render status: 200
  end

  # GET api/pages/category
  def fetch_categories
    # @page_categories = PageCategory.all.order('title ASC')
    # @roles = Role.all.order('name ASC')

    # TODO: The roles controller should be responsible for fetching the roles
    # render status: 200, json: { page_categories: @page_categories, roles: @roles }
    # render status: 200, json: @page_categories
  end

  # POST 'api/pages/category'
  # def create_category
  #   @page_category = PageCategory.new(category_params)
  #   if @page_category.save
  #     render status: 200, json: @page_category
  #   else
  #     render status: 500, json: { message: "Page category could not be created because: #{@page_category.errors.full_messages.to_sentence}" }
  #   end
  # end

  # PATCH api/pages/category
  # def update_category
  #   @page_category = PageCategory.find_by_id(params[:page_category][:id])
  #   if @page_category != nil
  #     if @page_category.update(category_params)
  #       render status: 200, json: @page_category
  #     else
  #       render status: 500, json: { message: "Page category could not be updated because: #{@page_category.errors.full_messages.to_sentence}" }
  #     end
  #   else
  #     render status: 404, json: { message: 'Page category not found' }
  #   end
  # end

  # DELETE api/pages/category/:page_category_id
  # def delete_category
  #   @page_category = PageCategory.find_by_id(params[:page_category][:id])
  #   if @page_category != nil
  #     # TODO
  #     # @page_category.pages.each do |page|
  #     #   page.page_category_id = nil
  #     #   page.save
  #     # end
  #     if @page_category.destroy
  #       render status: 200, json: { message: 'Page category deleted' }
  #     else
  #       render status: 500, json: { message: "Error Occured. Page category could not be deleted because: #{@page_category.errors.full_messages.to_sentence}" }
  #     end
  #   else
  #     render status: 404, json: { message: 'Page category not found' }
  #   end
  # end

  private
  def page_params
    params.require(:page).permit(:title, :subtitle, :content, :tags, :published, :classification_level_id)
  end

  private
  def page_update_params
    params.require(:page).permit(:id, :title, :subtitle, :content, :tags, :published, :classification_level_id)
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
