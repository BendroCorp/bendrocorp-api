require 'test_helper'

class SystemMapMoonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_map_moon = system_map_moons(:one)
  end

  test "should get index" do
    get system_map_moons_url, as: :json
    assert_response :success
  end

  test "should create system_map_moon" do
    assert_difference('SystemMapMoon.count') do
      post system_map_moons_url, params: { system_map_moon: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show system_map_moon" do
    get system_map_moon_url(@system_map_moon), as: :json
    assert_response :success
  end

  test "should update system_map_moon" do
    patch system_map_moon_url(@system_map_moon), params: { system_map_moon: {  } }, as: :json
    assert_response 200
  end

  test "should destroy system_map_moon" do
    assert_difference('SystemMapMoon.count', -1) do
      delete system_map_moon_url(@system_map_moon), as: :json
    end

    assert_response 204
  end
end
