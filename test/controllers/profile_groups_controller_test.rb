require 'test_helper'

class ProfileGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile_group = profile_groups(:one)
  end

  test "should get index" do
    get profile_groups_url, as: :json
    assert_response :success
  end

  test "should create profile_group" do
    assert_difference('ProfileGroup.count') do
      post profile_groups_url, params: { profile_group: { archived: @profile_group.archived, description: @profile_group.description, ordinal: @profile_group.ordinal, parent_id: @profile_group.parent_id, title: @profile_group.title } }, as: :json
    end

    assert_response 201
  end

  test "should show profile_group" do
    get profile_group_url(@profile_group), as: :json
    assert_response :success
  end

  test "should update profile_group" do
    patch profile_group_url(@profile_group), params: { profile_group: { archived: @profile_group.archived, description: @profile_group.description, ordinal: @profile_group.ordinal, parent_id: @profile_group.parent_id, title: @profile_group.title } }, as: :json
    assert_response 200
  end

  test "should destroy profile_group" do
    assert_difference('ProfileGroup.count', -1) do
      delete profile_group_url(@profile_group), as: :json
    end

    assert_response 204
  end
end
