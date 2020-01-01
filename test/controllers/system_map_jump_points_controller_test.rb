require 'test_helper'

class SystemMapJumpPointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_map_jump_point = system_map_jump_points(:one)
  end

  test "should get index" do
    get system_map_jump_points_url, as: :json
    assert_response :success
  end

  test "should create system_map_jump_point" do
    assert_difference('SystemMapJumpPoint.count') do
      post system_map_jump_points_url, params: { system_map_jump_point: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show system_map_jump_point" do
    get system_map_jump_point_url(@system_map_jump_point), as: :json
    assert_response :success
  end

  test "should update system_map_jump_point" do
    patch system_map_jump_point_url(@system_map_jump_point), params: { system_map_jump_point: {  } }, as: :json
    assert_response 200
  end

  test "should destroy system_map_jump_point" do
    assert_difference('SystemMapJumpPoint.count', -1) do
      delete system_map_jump_point_url(@system_map_jump_point), as: :json
    end

    assert_response 204
  end
end
