require "test_helper"

class IncidentReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @incident_report = incident_reports(:one)
  end

  test "should get index" do
    get incident_reports_url, as: :json
    assert_response :success
  end

  test "should create incident_report" do
    assert_difference('IncidentReport.count') do
      post incident_reports_url, params: { incident_report: { accepted: @incident_report.accepted, archived: @incident_report.archived, created_by_id: @incident_report.created_by_id, description: @incident_report.description, force_used_id: @incident_report.force_used_id, occured_when: @incident_report.occured_when, rsi_handle: @incident_report.rsi_handle, ship_used_id: @incident_report.ship_used_id, star_object_id: @incident_report.star_object_id, violence_rating_id: @incident_report.violence_rating_id } }, as: :json
    end

    assert_response 201
  end

  test "should show incident_report" do
    get incident_report_url(@incident_report), as: :json
    assert_response :success
  end

  test "should update incident_report" do
    patch incident_report_url(@incident_report), params: { incident_report: { accepted: @incident_report.accepted, archived: @incident_report.archived, created_by_id: @incident_report.created_by_id, description: @incident_report.description, force_used_id: @incident_report.force_used_id, occured_when: @incident_report.occured_when, rsi_handle: @incident_report.rsi_handle, ship_used_id: @incident_report.ship_used_id, star_object_id: @incident_report.star_object_id, violence_rating_id: @incident_report.violence_rating_id } }, as: :json
    assert_response 200
  end

  test "should destroy incident_report" do
    assert_difference('IncidentReport.count', -1) do
      delete incident_report_url(@incident_report), as: :json
    end

    assert_response 204
  end
end
