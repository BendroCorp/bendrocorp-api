class RpNewsStoriesController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action except: [:index, :show] do |a|
    a.require_one_role([44])
  end
  before_action :set_rp_news_story, only: [:show, :update, :destroy]

  # GET /api/news
  def index
    @rp_news_stories = RpNewsStory.where(archived: false)

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
      render json: @rp_news_story.as_json(include: { created_by: { only: [:id], methods: [:main_character] }, updated_by: { only: [:id], methods: [:main_character] } }), status: :created, location: @rp_news_story
    else
      render status: :unprocessable_entity, json: { message: @rp_news_story.errors.full_messages.to_sentence }
    end
  end

  # PATCH/PUT /api/news/
  def update
    if @rp_news_story
      @rp_news_story.updated_by_id = current_user.id
      if @rp_news_story.update(rp_news_story_params)
        render json: @rp_news_story.as_json(include: { created_by: { only: [:id], methods: [:main_character] }, updated_by: { only: [:id], methods: [:main_character] } })
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
      @rp_news_story = RpNewsStory.find_by_id(params[:news_id])
      @rp_news_story = RpNewsStory.find_by_id(params[:news_story][:id]) if @rp_news_story.nil?
    end

    # Only allow a trusted parameter "white list" through.
    def rp_news_story_params
      params.require(:news_story).permit(:title, :text)
    end
end
