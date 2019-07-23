class RpNewsStoriesController < ApplicationController
  before_action :require_user, except: [:index_public]
  before_action :require_member, except: [:index_public]
  before_action except: [:index, :show, :index_public] do |a|
    a.require_one_role([44])
  end
  before_action :set_rp_news_story, only: [:show, :update, :destroy]

  # GET /api/news
  def index
    @rp_news_stories = RpNewsStory.where(archived: false).order('created_at desc') if current_user.is_in_role 44
    @rp_news_stories ||= RpNewsStory.where(archived: false, published: true).order('created_at desc') if !current_user.is_in_role 44
    
    render json: @rp_news_stories.as_json(include: { created_by: { only: [:id], methods: [:main_character] }, updated_by: { only: [:id], methods: [:main_character] } })
  end

  # GET /api/news/public
  def index_public
    @rp_news_stories = RpNewsStory.where(archived: false, published: true, public: true).order('created_at desc')

    render json: @rp_news_stories.as_json(include: { created_by: { only: [:id], methods: [:main_character] }, updated_by: { only: [:id], methods: [:main_character] } })
  end

  # GET /api/news/:news_id
  def show
    if @rp_news_story
      render json: @rp_news_story.as_json(include: { created_by: { only: [:id], methods: [:main_character] }, updated_by: { only: [:id], methods: [:main_character] } })
    else
      render status: 404, json: { message: 'News item could not be found or was removed!' }
    end
  end

  # POST /api/news
  def create
    @rp_news_story = RpNewsStory.new(rp_news_story_params)

    @rp_news_story.created_by_id = current_user.id
    @rp_news_story.updated_by_id = current_user.id

    if @rp_news_story.save
      render status: 200, json: @rp_news_story.as_json(include: { created_by: { only: [:id], methods: [:main_character] }, updated_by: { only: [:id], methods: [:main_character] } })
    else
      render status: :unprocessable_entity, json: { message: @rp_news_story.errors.full_messages.to_sentence }
    end
  end

  # PATCH/PUT /api/news/
  def update
    if @rp_news_story
      @rp_news_story.updated_by_id = current_user.id
      if @rp_news_story.update(rp_news_story_params)
        render status: 200, json: @rp_news_story.as_json(include: { created_by: { only: [:id], methods: [:main_character] }, updated_by: { only: [:id], methods: [:main_character] } })
      else
        render status: :unprocessable_entity, json: { message: @rp_news_story.errors.full_messages.to_sentence }
      end
    else
      render status: 404, json: { message: 'News item could not be found or was removed!' }
    end
  end

  # DELETE /api/news/:news_id
  def destroy
    if @rp_news_story
      @rp_news_story.updated_by_id = current_user.id
      @rp_news_story.archived = true
      if @rp_news_story.save
        render json: { message: 'News story archived!' }
      else
        render status: :unprocessable_entity, json: { message: @rp_news_story.errors.full_messages.to_sentence }
      end
    else
      render status: 404, json: { message: 'News item could not be found or was removed!' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rp_news_story
      ns = RpNewsStory.find_by_id(params[:news_id].to_i)
      ns ||= RpNewsStory.find_by_id(params[:news_story][:id].to_i) if params[:news_story] && params[:news_story][:id].to_i
      
      if ns.archived == false && (ns.published == true || current_user.is_in_role(44))
        @rp_news_story = ns
      end
    end

    # Only allow a trusted parameter "white list" through.
    def rp_news_story_params
      params.require(:news_story).permit(:title, :text, :public, :published)
    end
end
