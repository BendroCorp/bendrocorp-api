require 'test_helper'

class SystemMapLocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_map_location = system_map_locations(:one)
  end

  test "should get index" do
    get system_map_locations_url, as: :json
    assert_response :success
  end

  test "should create system_map_location" do
    assert_difference('SystemMapLocation.count') do
      post system_map_locations_url, params: { system_map_location: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show system_map_location" do
    get system_map_location_url(@system_map_location), as: :json
    assert_response :success
  end

  test "should update system_map_location" do
    patch system_map_location_url(@system_map_location), params: { system_map_location: {  } }, as: :json
    assert_response 200
  end

  test "should destroy system_map_location" do
    assert_difference('SystemMapLocation.count', -1) do
      delete system_map_location_url(@system_map_location), as: :json
    end

    assert_response 204
  end
end
