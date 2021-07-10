require "test_helper"

class IntelligenceCasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @intelligence_case = intelligence_cases(:one)
  end

  test "should get index" do
    get intelligence_cases_url, as: :json
    assert_response :success
  end

  test "should create intelligence_case" do
    assert_difference('IntelligenceCase.count') do
      post intelligence_cases_url, params: { intelligence_case: { classification_level_id: @intelligence_case.classification_level_id, description: @intelligence_case.description, rsi_handle: @intelligence_case.rsi_handle, show_in_safe: @intelligence_case.show_in_safe, threat_level: @intelligence_case.threat_level, title: @intelligence_case.title, user_id: @intelligence_case.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show intelligence_case" do
    get intelligence_case_url(@intelligence_case), as: :json
    assert_response :success
  end

  test "should update intelligence_case" do
    patch intelligence_case_url(@intelligence_case), params: { intelligence_case: { classification_level_id: @intelligence_case.classification_level_id, description: @intelligence_case.description, rsi_handle: @intelligence_case.rsi_handle, show_in_safe: @intelligence_case.show_in_safe, threat_level: @intelligence_case.threat_level, title: @intelligence_case.title, user_id: @intelligence_case.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy intelligence_case" do
    assert_difference('IntelligenceCase.count', -1) do
      delete intelligence_case_url(@intelligence_case), as: :json
    end

    assert_response 204
  end
end
