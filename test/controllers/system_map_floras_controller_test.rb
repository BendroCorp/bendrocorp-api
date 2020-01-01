require 'test_helper'

class SystemMapFlorasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_map_flora = system_map_floras(:one)
  end

  test "should get index" do
    get system_map_floras_url, as: :json
    assert_response :success
  end

  test "should create system_map_flora" do
    assert_difference('SystemMapFlora.count') do
      post system_map_floras_url, params: { system_map_flora: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show system_map_flora" do
    get system_map_flora_url(@system_map_flora), as: :json
    assert_response :success
  end

  test "should update system_map_flora" do
    patch system_map_flora_url(@system_map_flora), params: { system_map_flora: {  } }, as: :json
    assert_response 200
  end

  test "should destroy system_map_flora" do
    assert_difference('SystemMapFlora.count', -1) do
      delete system_map_flora_url(@system_map_flora), as: :json
    end

    assert_response 204
  end
end
