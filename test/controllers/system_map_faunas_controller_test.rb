require 'test_helper'

class SystemMapFaunasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_map_fauna = system_map_faunas(:one)
  end

  test "should get index" do
    get system_map_faunas_url, as: :json
    assert_response :success
  end

  test "should create system_map_fauna" do
    assert_difference('SystemMapFauna.count') do
      post system_map_faunas_url, params: { system_map_fauna: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show system_map_fauna" do
    get system_map_fauna_url(@system_map_fauna), as: :json
    assert_response :success
  end

  test "should update system_map_fauna" do
    patch system_map_fauna_url(@system_map_fauna), params: { system_map_fauna: {  } }, as: :json
    assert_response 200
  end

  test "should destroy system_map_fauna" do
    assert_difference('SystemMapFauna.count', -1) do
      delete system_map_fauna_url(@system_map_fauna), as: :json
    end

    assert_response 204
  end
end
