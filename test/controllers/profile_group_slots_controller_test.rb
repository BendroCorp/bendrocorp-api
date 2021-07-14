require "test_helper"

class ProfileGroupSlotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile_group_slot = profile_group_slots(:one)
  end

  test "should get index" do
    get profile_group_slots_url, as: :json
    assert_response :success
  end

  test "should create profile_group_slot" do
    assert_difference('ProfileGroupSlot.count') do
      post profile_group_slots_url, params: { profile_group_slot: { character_id: @profile_group_slot.character_id, exempt: @profile_group_slot.exempt, first_warn: @profile_group_slot.first_warn, ordinal: @profile_group_slot.ordinal, profile_group_id: @profile_group_slot.profile_group_id, role_id: @profile_group_slot.role_id, second_warn: @profile_group_slot.second_warn, slot_status_id: @profile_group_slot.slot_status_id, title: @profile_group_slot.title } }, as: :json
    end

    assert_response 201
  end

  test "should show profile_group_slot" do
    get profile_group_slot_url(@profile_group_slot), as: :json
    assert_response :success
  end

  test "should update profile_group_slot" do
    patch profile_group_slot_url(@profile_group_slot), params: { profile_group_slot: { character_id: @profile_group_slot.character_id, exempt: @profile_group_slot.exempt, first_warn: @profile_group_slot.first_warn, ordinal: @profile_group_slot.ordinal, profile_group_id: @profile_group_slot.profile_group_id, role_id: @profile_group_slot.role_id, second_warn: @profile_group_slot.second_warn, slot_status_id: @profile_group_slot.slot_status_id, title: @profile_group_slot.title } }, as: :json
    assert_response 200
  end

  test "should destroy profile_group_slot" do
    assert_difference('ProfileGroupSlot.count', -1) do
      delete profile_group_slot_url(@profile_group_slot), as: :json
    end

    assert_response 204
  end
end
