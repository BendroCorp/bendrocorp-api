require 'test_helper'

class SystemMapSettlementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @system_map_settlement = system_map_settlements(:one)
  end

  test "should get index" do
    get system_map_settlements_url, as: :json
    assert_response :success
  end

  test "should create system_map_settlement" do
    assert_difference('SystemMapSettlement.count') do
      post system_map_settlements_url, params: { system_map_settlement: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show system_map_settlement" do
    get system_map_settlement_url(@system_map_settlement), as: :json
    assert_response :success
  end

  test "should update system_map_settlement" do
    patch system_map_settlement_url(@system_map_settlement), params: { system_map_settlement: {  } }, as: :json
    assert_response 200
  end

  test "should destroy system_map_settlement" do
    assert_difference('SystemMapSettlement.count', -1) do
      delete system_map_settlement_url(@system_map_settlement), as: :json
    end

    assert_response 204
  end
end
