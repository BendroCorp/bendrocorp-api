require 'test_helper'

class SystemMapMissionGiversControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_map_mission_giver = system_map_mission_givers(:one)
  end

  test "should get index" do
    get system_map_mission_givers_url, as: :json
    assert_response :success
  end

  test "should create system_map_mission_giver" do
    assert_difference('SystemMapMissionGiver.count') do
      post system_map_mission_givers_url, params: { system_map_mission_giver: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show system_map_mission_giver" do
    get system_map_mission_giver_url(@system_map_mission_giver), as: :json
    assert_response :success
  end

  test "should update system_map_mission_giver" do
    patch system_map_mission_giver_url(@system_map_mission_giver), params: { system_map_mission_giver: {  } }, as: :json
    assert_response 200
  end

  test "should destroy system_map_mission_giver" do
    assert_difference('SystemMapMissionGiver.count', -1) do
      delete system_map_mission_giver_url(@system_map_mission_giver), as: :json
    end

    assert_response 204
  end
end
