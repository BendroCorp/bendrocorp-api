require 'test_helper'

class SystemMapImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_map_image = system_map_images(:one)
  end

  test "should get index" do
    get system_map_images_url, as: :json
    assert_response :success
  end

  test "should create system_map_image" do
    assert_difference('SystemMapImage.count') do
      post system_map_images_url, params: { system_map_image: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show system_map_image" do
    get system_map_image_url(@system_map_image), as: :json
    assert_response :success
  end

  test "should update system_map_image" do
    patch system_map_image_url(@system_map_image), params: { system_map_image: {  } }, as: :json
    assert_response 200
  end

  test "should destroy system_map_image" do
    assert_difference('SystemMapImage.count', -1) do
      delete system_map_image_url(@system_map_image), as: :json
    end

    assert_response 204
  end
end
