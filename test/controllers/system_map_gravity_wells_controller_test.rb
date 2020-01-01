require 'test_helper'

class SystemMapGravityWellsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_map_gravity_well = system_map_gravity_wells(:one)
  end

  test "should get index" do
    get system_map_gravity_wells_url, as: :json
    assert_response :success
  end

  test "should create system_map_gravity_well" do
    assert_difference('SystemMapGravityWell.count') do
      post system_map_gravity_wells_url, params: { system_map_gravity_well: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show system_map_gravity_well" do
    get system_map_gravity_well_url(@system_map_gravity_well), as: :json
    assert_response :success
  end

  test "should update system_map_gravity_well" do
    patch system_map_gravity_well_url(@system_map_gravity_well), params: { system_map_gravity_well: {  } }, as: :json
    assert_response 200
  end

  test "should destroy system_map_gravity_well" do
    assert_difference('SystemMapGravityWell.count', -1) do
      delete system_map_gravity_well_url(@system_map_gravity_well), as: :json
    end

    assert_response 204
  end
end
