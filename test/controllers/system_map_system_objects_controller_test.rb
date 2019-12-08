require 'test_helper'

class SystemMapSystemObjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_map_system_object = system_map_system_objects(:one)
  end

  test "should get index" do
    get system_map_system_objects_url, as: :json
    assert_response :success
  end

  test "should create system_map_system_object" do
    assert_difference('SystemMapSystemObject.count') do
      post system_map_system_objects_url, params: { system_map_system_object: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show system_map_system_object" do
    get system_map_system_object_url(@system_map_system_object), as: :json
    assert_response :success
  end

  test "should update system_map_system_object" do
    patch system_map_system_object_url(@system_map_system_object), params: { system_map_system_object: {  } }, as: :json
    assert_response 200
  end

  test "should destroy system_map_system_object" do
    assert_difference('SystemMapSystemObject.count', -1) do
      delete system_map_system_object_url(@system_map_system_object), as: :json
    end

    assert_response 204
  end
end
