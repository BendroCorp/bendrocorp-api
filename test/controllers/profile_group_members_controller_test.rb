require 'test_helper'

class ProfileGroupMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile_group_member = profile_group_members(:one)
  end

  test "should get index" do
    get profile_group_members_url, as: :json
    assert_response :success
  end

  test "should create profile_group_member" do
    assert_difference('ProfileGroupMember.count') do
      post profile_group_members_url, params: { profile_group_member: { character_id: @profile_group_member.character_id, member_title: @profile_group_member.member_title, ordinal: @profile_group_member.ordinal, profile_group_id: @profile_group_member.profile_group_id } }, as: :json
    end

    assert_response 201
  end

  test "should show profile_group_member" do
    get profile_group_member_url(@profile_group_member), as: :json
    assert_response :success
  end

  test "should update profile_group_member" do
    patch profile_group_member_url(@profile_group_member), params: { profile_group_member: { character_id: @profile_group_member.character_id, member_title: @profile_group_member.member_title, ordinal: @profile_group_member.ordinal, profile_group_id: @profile_group_member.profile_group_id } }, as: :json
    assert_response 200
  end

  test "should destroy profile_group_member" do
    assert_difference('ProfileGroupMember.count', -1) do
      delete profile_group_member_url(@profile_group_member), as: :json
    end

    assert_response 204
  end
end
