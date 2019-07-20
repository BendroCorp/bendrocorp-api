require 'test_helper'

class RpNewsStoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rp_news_story = rp_news_stories(:one)
  end

  test "should get index" do
    get rp_news_stories_url, as: :json
    assert_response :success
  end

  test "should create rp_news_story" do
    assert_difference('RpNewsStory.count') do
      post rp_news_stories_url, params: { rp_news_story: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show rp_news_story" do
    get rp_news_story_url(@rp_news_story), as: :json
    assert_response :success
  end

  test "should update rp_news_story" do
    patch rp_news_story_url(@rp_news_story), params: { rp_news_story: {  } }, as: :json
    assert_response 200
  end

  test "should destroy rp_news_story" do
    assert_difference('RpNewsStory.count', -1) do
      delete rp_news_story_url(@rp_news_story), as: :json
    end

    assert_response 204
  end
end
