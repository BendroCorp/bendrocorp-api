require 'test_helper'

class SystemMapPlanetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_map_planet = system_map_planets(:one)
  end

  test "should get index" do
    get system_map_planets_url, as: :json
    assert_response :success
  end

  test "should create system_map_planet" do
    assert_difference('SystemMapPlanet.count') do
      post system_map_planets_url, params: { system_map_planet: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show system_map_planet" do
    get system_map_planet_url(@system_map_planet), as: :json
    assert_response :success
  end

  test "should update system_map_planet" do
    patch system_map_planet_url(@system_map_planet), params: { system_map_planet: {  } }, as: :json
    assert_response 200
  end

  test "should destroy system_map_planet" do
    assert_difference('SystemMapPlanet.count', -1) do
      delete system_map_planet_url(@system_map_planet), as: :json
    end

    assert_response 204
  end
end
