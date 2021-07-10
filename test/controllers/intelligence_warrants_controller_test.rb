require "test_helper"

class IntelligenceWarrantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @intelligence_warrant = intelligence_warrants(:one)
  end

  test "should get index" do
    get intelligence_warrants_url, as: :json
    assert_response :success
  end

  test "should create intelligence_warrant" do
    assert_difference('IntelligenceWarrant.count') do
      post intelligence_warrants_url, params: { intelligence_warrant: { archived: @intelligence_warrant.archived, boolean: @intelligence_warrant.boolean, closed: @intelligence_warrant.closed, intelligence_case_id: @intelligence_warrant.intelligence_case_id, warrant_status_id: @intelligence_warrant.warrant_status_id } }, as: :json
    end

    assert_response 201
  end

  test "should show intelligence_warrant" do
    get intelligence_warrant_url(@intelligence_warrant), as: :json
    assert_response :success
  end

  test "should update intelligence_warrant" do
    patch intelligence_warrant_url(@intelligence_warrant), params: { intelligence_warrant: { archived: @intelligence_warrant.archived, boolean: @intelligence_warrant.boolean, closed: @intelligence_warrant.closed, intelligence_case_id: @intelligence_warrant.intelligence_case_id, warrant_status_id: @intelligence_warrant.warrant_status_id } }, as: :json
    assert_response 200
  end

  test "should destroy intelligence_warrant" do
    assert_difference('IntelligenceWarrant.count', -1) do
      delete intelligence_warrant_url(@intelligence_warrant), as: :json
    end

    assert_response 204
  end
end
