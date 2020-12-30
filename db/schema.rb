# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20200725013618) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "pgcrypto"

  create_table "activities", force: :cascade do |t|
    t.text "text"
    t.string "icon"
    t.boolean "admin_only", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "add_system_map_item_requests", force: :cascade do |t|
    t.bigint "system_map_object_kind_id"
    t.integer "kind_pk"
    t.bigint "user_id"
    t.bigint "approval_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_add_system_map_item_requests_on_approval_id"
    t.index ["user_id"], name: "index_add_system_map_item_requests_on_user_id"
  end

  create_table "alert_types", force: :cascade do |t|
    t.text "title"
    t.text "sub_title"
    t.text "description"
    t.text "color"
    t.boolean "selectable", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "alerts", force: :cascade do |t|
    t.text "message"
    t.integer "expire_hours"
    t.datetime "expires"
    t.boolean "archived"
    t.bigint "system_id"
    t.bigint "planet_id"
    t.bigint "moon_id"
    t.bigint "system_object_id"
    t.bigint "settlement_id"
    t.bigint "location_id"
    t.bigint "alert_type_id"
    t.bigint "issued_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alert_type_id"], name: "index_alerts_on_alert_type_id"
    t.index ["issued_by_id"], name: "index_alerts_on_issued_by_id"
    t.index ["location_id"], name: "index_alerts_on_location_id"
    t.index ["moon_id"], name: "index_alerts_on_moon_id"
    t.index ["planet_id"], name: "index_alerts_on_planet_id"
    t.index ["settlement_id"], name: "index_alerts_on_settlement_id"
    t.index ["system_id"], name: "index_alerts_on_system_id"
    t.index ["system_object_id"], name: "index_alerts_on_system_object_id"
  end

  create_table "applicant_approval_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "approval_id"
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_applicant_approval_requests_on_application_id"
    t.index ["approval_id"], name: "index_applicant_approval_requests_on_approval_id"
    t.index ["user_id"], name: "index_applicant_approval_requests_on_user_id"
  end

  create_table "application_approvers", force: :cascade do |t|
    t.bigint "application_id"
    t.bigint "user_id"
    t.bigint "approval_type_id"
    t.datetime "last_notified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_application_approvers_on_application_id"
    t.index ["approval_type_id"], name: "index_application_approvers_on_approval_type_id"
    t.index ["user_id"], name: "index_application_approvers_on_user_id"
  end

  create_table "application_comments", force: :cascade do |t|
    t.text "comment"
    t.bigint "user_id"
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_application_comments_on_application_id"
    t.index ["user_id"], name: "index_application_comments_on_user_id"
  end

  create_table "application_interviews", force: :cascade do |t|
    t.text "tell_us_about_yourself"
    t.boolean "applicant_has_read_soc"
    t.boolean "applicant_agrees_to_respect_for_leadership"
    t.boolean "applicant_agrees_to_voice_policy"
    t.boolean "applicant_agrees_to_roleplay_style"
    t.boolean "applicant_agrees_to_follow_all_policies"
    t.boolean "applicant_agrees_to_understands_participation"
    t.text "why_selected_division"
    t.text "why_join_bendrocorp"
    t.text "applicant_questions"
    t.text "other_questions"
    t.text "interview_consensous"
    t.boolean "locked_for_review", default: false
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_application_interviews_on_application_id"
  end

  create_table "application_statuses", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "applications", force: :cascade do |t|
    t.text "tell_us_about_the_real_you"
    t.text "why_do_want_to_join"
    t.text "how_did_you_hear_about_us"
    t.bigint "application_interview_id"
    t.bigint "application_status_id"
    t.datetime "last_status_change"
    t.bigint "last_status_changed_by_id"
    t.bigint "job_id"
    t.bigint "character_id"
    t.text "rejection_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_interview_id"], name: "index_applications_on_application_interview_id"
    t.index ["application_status_id"], name: "index_applications_on_application_status_id"
    t.index ["character_id"], name: "index_applications_on_character_id"
    t.index ["job_id"], name: "index_applications_on_job_id"
    t.index ["last_status_changed_by_id"], name: "index_applications_on_last_status_changed_by_id"
  end

  create_table "approval_approvers", force: :cascade do |t|
    t.bigint "approval_id"
    t.bigint "user_id"
    t.bigint "approval_type_id"
    t.datetime "last_notified"
    t.boolean "required", default: true
    t.text "decline_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_approval_approvers_on_approval_id"
    t.index ["approval_type_id"], name: "index_approval_approvers_on_approval_type_id"
    t.index ["user_id"], name: "index_approval_approvers_on_user_id"
  end

  create_table "approval_kinds", force: :cascade do |t|
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval_types", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approval_workflows", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "approvals", force: :cascade do |t|
    t.bigint "approval_kind_id"
    t.boolean "full_consent", default: false
    t.boolean "single_consent", default: false
    t.boolean "denied", default: false
    t.boolean "approved", default: false
    t.uuid "report_id"
    t.boolean "bound", default: false
    t.integer "bound_tries", default: 0
    t.boolean "notifications_sent", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_kind_id"], name: "index_approvals_on_approval_kind_id"
    t.index ["report_id"], name: "index_approvals_on_report_id"
  end

  create_table "approver_roles", force: :cascade do |t|
    t.bigint "approval_kind_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_kind_id"], name: "index_approver_roles_on_approval_kind_id"
    t.index ["role_id"], name: "index_approver_roles_on_role_id"
  end

  create_table "attendence_types", force: :cascade do |t|
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendences", force: :cascade do |t|
    t.bigint "attendence_type_id"
    t.boolean "certified", default: false
    t.bigint "user_id"
    t.bigint "character_id"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendence_type_id"], name: "index_attendences_on_attendence_type_id"
    t.index ["character_id"], name: "index_attendences_on_character_id"
    t.index ["event_id"], name: "index_attendences_on_event_id"
    t.index ["user_id"], name: "index_attendences_on_user_id"
  end

  create_table "award_requests", force: :cascade do |t|
    t.text "citation"
    t.bigint "on_behalf_of_id"
    t.bigint "award_id"
    t.bigint "approval_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_award_requests_on_approval_id"
    t.index ["award_id"], name: "index_award_requests_on_award_id"
    t.index ["on_behalf_of_id"], name: "index_award_requests_on_on_behalf_of_id"
    t.index ["user_id"], name: "index_award_requests_on_user_id"
  end

  create_table "awards", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.integer "points"
    t.boolean "multiple_awards_allowed", default: false
    t.boolean "outofband_awards_allowed", default: true
    t.bigint "create_award_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.index ["create_award_request_id"], name: "index_awards_on_create_award_request_id"
  end

  create_table "awards_awardeds", force: :cascade do |t|
    t.text "citation"
    t.bigint "character_id"
    t.bigint "award_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["award_id"], name: "index_awards_awardeds_on_award_id"
    t.index ["character_id"], name: "index_awards_awardeds_on_character_id"
  end

  create_table "badges", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "image_link"
    t.integer "ordinal"
    t.bigint "created_by_id"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_badges_on_created_by_id"
  end

  create_table "bot_reminders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "bot_id"
    t.bigint "created_by_id"
    t.text "message"
    t.integer "recur_every", default: 0
    t.datetime "last_notification"
    t.datetime "expires"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bot_id"], name: "index_bot_reminders_on_bot_id"
    t.index ["created_by_id"], name: "index_bot_reminders_on_created_by_id"
  end

  create_table "bots", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "bot_name"
    t.text "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "character_genders", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "character_species", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "characters", force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "nickname"
    t.text "description"
    t.text "background"
    t.bigint "job_id"
    t.bigint "user_id"
    t.bigint "gender_id"
    t.bigint "species_id"
    t.boolean "is_main_character", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["gender_id"], name: "index_characters_on_gender_id"
    t.index ["job_id"], name: "index_characters_on_job_id"
    t.index ["species_id"], name: "index_characters_on_species_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "chat_rooms", force: :cascade do |t|
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats", force: :cascade do |t|
    t.text "text"
    t.boolean "edited"
    t.bigint "chat_room_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_room_id"], name: "index_chats_on_chat_room_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "classification_level_roles", force: :cascade do |t|
    t.bigint "classification_level_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classification_level_id"], name: "index_classification_level_roles_on_classification_level_id"
    t.index ["role_id"], name: "index_classification_level_roles_on_role_id"
  end

  create_table "classification_levels", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.string "color"
    t.integer "ordinal"
    t.boolean "compartmentalized", default: false
    t.boolean "hidden", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classification_request_types", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "class"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classification_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "approval_id"
    t.bigint "classification_request_type_id"
    t.integer "requested_item"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_classification_requests_on_approval_id"
    t.index ["classification_request_type_id"], name: "index_classification_request_to_type"
    t.index ["user_id"], name: "index_classification_requests_on_user_id"
  end

  create_table "create_award_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "award_id"
    t.bigint "approval_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_create_award_requests_on_approval_id"
    t.index ["award_id"], name: "index_create_award_requests_on_award_id"
    t.index ["user_id"], name: "index_create_award_requests_on_user_id"
  end

  create_table "discord_identities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "discord_username"
    t.text "discord_id"
    t.text "refresh_token"
    t.boolean "joined", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_discord_identities_on_user_id"
  end

  create_table "division_groups", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.integer "ordinal"
    t.bigint "division_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["division_id"], name: "index_division_groups_on_division_id"
  end

  create_table "division_in_groups", force: :cascade do |t|
    t.text "group_member_title"
    t.bigint "character_id"
    t.bigint "division_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_division_in_groups_on_character_id"
    t.index ["division_group_id"], name: "index_division_in_groups_on_division_group_id"
  end

  create_table "divisions", force: :cascade do |t|
    t.text "name"
    t.text "color"
    t.text "font_color"
    t.text "short_name"
    t.text "description"
    t.boolean "can_have_ships", default: true
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "donation_items", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.integer "goal"
    t.datetime "goal_date"
    t.bigint "created_by_id"
    t.boolean "archived", default: false
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_donation_items_on_created_by_id"
  end

  create_table "donations", force: :cascade do |t|
    t.bigint "donation_item_id"
    t.bigint "user_id"
    t.integer "amount"
    t.text "stripe_transaction_id"
    t.boolean "charge_succeeded", default: false
    t.boolean "charge_failed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donation_item_id"], name: "index_donations_on_donation_item_id"
    t.index ["user_id"], name: "index_donations_on_user_id"
  end

  create_table "event_auto_attendances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "user_id"
    t.boolean "processed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_auto_attendances_on_event_id"
    t.index ["user_id"], name: "index_event_auto_attendances_on_user_id"
  end

  create_table "event_awards", force: :cascade do |t|
    t.bigint "award_id"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["award_id"], name: "index_event_awards_on_award_id"
    t.index ["event_id"], name: "index_event_awards_on_event_id"
  end

  create_table "event_briefings", force: :cascade do |t|
    t.bigint "operational_leader_id"
    t.bigint "reporting_designee_id"
    t.bigint "communications_designee_id"
    t.bigint "escort_leader_id"
    t.text "objective"
    t.text "notes"
    t.bigint "starting_system_id"
    t.bigint "ending_system_id"
    t.boolean "published", default: false
    t.datetime "published_when"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["communications_designee_id"], name: "index_event_briefings_on_communications_designee_id"
    t.index ["ending_system_id"], name: "index_event_briefings_on_ending_system_id"
    t.index ["escort_leader_id"], name: "index_event_briefings_on_escort_leader_id"
    t.index ["event_id"], name: "index_event_briefings_on_event_id"
    t.index ["operational_leader_id"], name: "index_event_briefings_on_operational_leader_id"
    t.index ["reporting_designee_id"], name: "index_event_briefings_on_reporting_designee_id"
    t.index ["starting_system_id"], name: "index_event_briefings_on_starting_system_id"
  end

  create_table "event_certification_requests", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "approval_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_event_certification_requests_on_approval_id"
    t.index ["event_id"], name: "index_event_certification_requests_on_event_id"
    t.index ["user_id"], name: "index_event_certification_requests_on_user_id"
  end

  create_table "event_debriefings", force: :cascade do |t|
    t.text "text"
    t.boolean "published", default: false
    t.boolean "published_when"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_debriefings_on_event_id"
  end

  create_table "event_ships", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "owned_ship_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_ships_on_event_id"
    t.index ["owned_ship_id"], name: "index_event_ships_on_owned_ship_id"
  end

  create_table "event_types", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean "weekly_recurrence", default: false
    t.boolean "monthly_recurrence", default: false
    t.boolean "recurred", default: false
    t.bigint "event_type_id"
    t.text "livestream_url"
    t.boolean "submitted_for_certification", default: false
    t.boolean "certified", default: false
    t.bigint "event_certification_request_id"
    t.boolean "show_on_dashboard", default: true
    t.boolean "published", default: false
    t.datetime "published_date"
    t.boolean "published_discord", default: false
    t.boolean "published_final_discord", default: false
    t.bigint "briefing_id"
    t.bigint "debriefing_id"
    t.bigint "classification_level_id"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["briefing_id"], name: "index_events_on_briefing_id"
    t.index ["classification_level_id"], name: "index_events_on_classification_level_id"
    t.index ["debriefing_id"], name: "index_events_on_debriefing_id"
    t.index ["event_certification_request_id"], name: "index_events_on_event_certification_request_id"
    t.index ["event_type_id"], name: "index_events_on_event_type_id"
  end

  create_table "faction_affiliations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "color"
    t.bigint "primary_image_id"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["primary_image_id"], name: "index_faction_affiliations_on_primary_image_id"
  end

  create_table "field_descriptor_classes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "class_name"
    t.text "class_field"
    t.boolean "restrict_by_owner", default: false
    t.text "owner_field_name"
    t.boolean "sort_by_date", default: false
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "field_descriptors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "field_id"
    t.text "title"
    t.text "description"
    t.text "ordinal"
    t.bigint "created_by_id"
    t.boolean "read_only", default: false
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_field_descriptors_on_created_by_id"
    t.index ["field_id"], name: "index_field_descriptors_on_field_id"
  end

  create_table "fields", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name"
    t.boolean "read_only", default: false
    t.uuid "field_descriptor_class_id"
    t.bigint "created_by_id"
    t.boolean "archived", default: false
    t.text "additional_data"
    t.boolean "multi_value_allowed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_fields_on_created_by_id"
    t.index ["field_descriptor_class_id"], name: "index_fields_on_field_descriptor_class_id"
  end

  create_table "flight_log_images", force: :cascade do |t|
    t.bigint "image_upload_id"
    t.bigint "flight_log_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flight_log_id"], name: "index_flight_log_images_on_flight_log_id"
    t.index ["image_upload_id"], name: "index_flight_log_images_on_image_upload_id"
  end

  create_table "flight_logs", force: :cascade do |t|
    t.text "title"
    t.text "text"
    t.boolean "public", default: false
    t.boolean "privacy_changes_allowed", default: true
    t.boolean "locked", default: false
    t.boolean "finalized", default: false
    t.bigint "owned_ship_id"
    t.uuid "system_id"
    t.uuid "planet_id"
    t.uuid "moon_id"
    t.uuid "system_object_id"
    t.uuid "settlement_id"
    t.uuid "location_id"
    t.bigint "offender_report_id"
    t.bigint "trade_calculation_id"
    t.bigint "log_owner_id"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_flight_logs_on_location_id"
    t.index ["log_owner_id"], name: "index_flight_logs_on_log_owner_id"
    t.index ["moon_id"], name: "index_flight_logs_on_moon_id"
    t.index ["offender_report_id"], name: "index_flight_logs_on_offender_report_id"
    t.index ["owned_ship_id"], name: "index_flight_logs_on_owned_ship_id"
    t.index ["planet_id"], name: "index_flight_logs_on_planet_id"
    t.index ["settlement_id"], name: "index_flight_logs_on_settlement_id"
    t.index ["system_id"], name: "index_flight_logs_on_system_id"
    t.index ["system_object_id"], name: "index_flight_logs_on_system_object_id"
    t.index ["trade_calculation_id"], name: "index_flight_logs_on_trade_calculation_id"
  end

  create_table "image_uploads", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.bigint "uploaded_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.index ["uploaded_by_id"], name: "index_image_uploads_on_uploaded_by_id"
  end

  create_table "in_roles", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_in_roles_on_role_id"
    t.index ["user_id"], name: "index_in_roles_on_user_id"
  end

  create_table "intelligence_reports", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.bigint "classification_level_id"
    t.bigint "submitted_by_id"
    t.bigint "offender_report_offender_id"
    t.bigint "offender_report_org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classification_level_id"], name: "index_intelligence_reports_on_classification_level_id"
    t.index ["offender_report_offender_id"], name: "index_intelligence_reports_on_offender_report_offender_id"
    t.index ["offender_report_org_id"], name: "index_intelligence_reports_on_offender_report_org_id"
    t.index ["submitted_by_id"], name: "index_intelligence_reports_on_submitted_by_id"
  end

  create_table "job_board_mission_acceptors", force: :cascade do |t|
    t.bigint "job_board_mission_id"
    t.bigint "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_job_board_mission_acceptors_on_character_id"
    t.index ["job_board_mission_id"], name: "index_job_board_mission_acceptors_on_job_board_mission_id"
  end

  create_table "job_board_mission_awards", force: :cascade do |t|
    t.bigint "award_id"
    t.bigint "job_board_mission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["award_id"], name: "index_job_board_mission_awards_on_award_id"
    t.index ["job_board_mission_id"], name: "index_job_board_mission_awards_on_job_board_mission_id"
  end

  create_table "job_board_mission_completion_criteria", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.boolean "flight_log_required", default: false
    t.boolean "child_approval_required", default: false
    t.bigint "child_approval_request_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_board_mission_completion_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "approval_id"
    t.bigint "job_board_mission_id"
    t.bigint "child_approval_id"
    t.bigint "flight_log_id"
    t.text "completion_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_job_board_mission_completion_requests_on_approval_id"
    t.index ["child_approval_id"], name: "completion_req_child_approval_id"
    t.index ["job_board_mission_id"], name: "completion_req_mission_id"
    t.index ["user_id"], name: "index_job_board_mission_completion_requests_on_user_id"
  end

  create_table "job_board_mission_creation_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "approval_id"
    t.bigint "job_board_mission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_job_board_mission_creation_requests_on_approval_id"
    t.index ["job_board_mission_id"], name: "creation_req_mission_id"
    t.index ["user_id"], name: "index_job_board_mission_creation_requests_on_user_id"
  end

  create_table "job_board_mission_statuses", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_board_missions", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.bigint "completion_criteria_id"
    t.datetime "expires_when"
    t.datetime "starts_when"
    t.integer "max_acceptors", default: 1
    t.datetime "accepted_when"
    t.datetime "acceptence_expires_when"
    t.integer "max_completion_hours", default: 72
    t.bigint "creation_request_id"
    t.bigint "completion_request_id"
    t.integer "op_value", default: 2
    t.bigint "mission_status_id"
    t.bigint "division_restriction_id"
    t.bigint "system_id"
    t.bigint "moon_id"
    t.bigint "planet_id"
    t.bigint "system_object_id"
    t.bigint "settlement_id"
    t.bigint "location_id"
    t.boolean "duplicated_in_spectrum"
    t.boolean "posting_approved", default: true
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completion_criteria_id"], name: "index_job_board_missions_on_completion_criteria_id"
    t.index ["completion_request_id"], name: "index_job_board_missions_on_completion_request_id"
    t.index ["created_by_id"], name: "index_job_board_missions_on_created_by_id"
    t.index ["creation_request_id"], name: "index_job_board_missions_on_creation_request_id"
    t.index ["division_restriction_id"], name: "index_job_board_missions_on_division_restriction_id"
    t.index ["location_id"], name: "index_job_board_missions_on_location_id"
    t.index ["mission_status_id"], name: "index_job_board_missions_on_mission_status_id"
    t.index ["moon_id"], name: "index_job_board_missions_on_moon_id"
    t.index ["planet_id"], name: "index_job_board_missions_on_planet_id"
    t.index ["settlement_id"], name: "index_job_board_missions_on_settlement_id"
    t.index ["system_id"], name: "index_job_board_missions_on_system_id"
    t.index ["system_object_id"], name: "index_job_board_missions_on_system_object_id"
    t.index ["updated_by_id"], name: "index_job_board_missions_on_updated_by_id"
  end

  create_table "job_change_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "approval_id"
    t.bigint "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_job_change_requests_on_approval_id"
    t.index ["job_id"], name: "index_job_change_requests_on_job_id"
    t.index ["user_id"], name: "index_job_change_requests_on_user_id"
  end

  create_table "job_levels", force: :cascade do |t|
    t.text "title"
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_trackings", force: :cascade do |t|
    t.bigint "job_id"
    t.bigint "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_job_trackings_on_character_id"
    t.index ["job_id"], name: "index_job_trackings_on_job_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "hiring_description"
    t.integer "recruit_job_id"
    t.integer "next_job_id"
    t.bigint "division_id"
    t.boolean "hiring", default: false
    t.bigint "job_level_id"
    t.integer "max"
    t.boolean "read_only", default: false
    t.boolean "op_eligible", default: true
    t.bigint "checks_max_headcount_from_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checks_max_headcount_from_id"], name: "index_jobs_on_checks_max_headcount_from_id"
    t.index ["division_id"], name: "index_jobs_on_division_id"
    t.index ["job_level_id"], name: "index_jobs_on_job_level_id"
  end

  create_table "jurisdiction_law_categories", force: :cascade do |t|
    t.text "title"
    t.integer "ordinal"
    t.boolean "archived", default: false
    t.bigint "jurisdiction_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_jurisdiction_law_categories_on_created_by_id"
    t.index ["jurisdiction_id"], name: "index_jurisdiction_law_categories_on_jurisdiction_id"
  end

  create_table "jurisdiction_laws", force: :cascade do |t|
    t.text "title"
    t.integer "law_class"
    t.float "fine_amount"
    t.boolean "archived", default: false
    t.bigint "jurisdiction_id"
    t.bigint "law_category_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_jurisdiction_laws_on_created_by_id"
    t.index ["jurisdiction_id"], name: "index_jurisdiction_laws_on_jurisdiction_id"
    t.index ["law_category_id"], name: "index_jurisdiction_laws_on_law_category_id"
  end

  create_table "jurisdictions", force: :cascade do |t|
    t.text "title"
    t.boolean "archived", default: false
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_jurisdictions_on_created_by_id"
  end

  create_table "mail_queue_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mail_queues", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "member_badges", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "badge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_member_badges_on_badge_id"
    t.index ["user_id"], name: "index_member_badges_on_user_id"
  end

  create_table "menu_item_roles", force: :cascade do |t|
    t.bigint "menu_item_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_item_id"], name: "index_menu_item_roles_on_menu_item_id"
    t.index ["role_id"], name: "index_menu_item_roles_on_role_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.text "title"
    t.text "icon"
    t.text "link"
    t.boolean "internal", default: true
    t.bigint "nested_under_id"
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nested_under_id"], name: "index_menu_items_on_nested_under_id"
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nested_roles", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "role_nested_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_nested_roles_on_role_id"
    t.index ["role_nested_id"], name: "index_nested_roles_on_role_nested_id"
  end

  create_table "oauth_clients", force: :cascade do |t|
    t.text "title"
    t.text "client_id"
    t.text "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_tokens", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "oauth_client_id"
    t.text "access_token"
    t.text "refresh_token"
    t.datetime "expires"
    t.text "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["oauth_client_id"], name: "index_oauth_tokens_on_oauth_client_id"
    t.index ["user_id"], name: "index_oauth_tokens_on_user_id"
  end

  create_table "offender_bounties", force: :cascade do |t|
    t.integer "reward"
    t.text "reason"
    t.boolean "bounty_on_rsi"
    t.text "rsi_bounty_link"
    t.boolean "bounty_completed"
    t.boolean "active", default: true
    t.bigint "offender_bounty_approval_request_id"
    t.bigint "offender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offender_bounty_approval_request_id"], name: "index_offender_bounties_on_offender_bounty_approval_request_id"
    t.index ["offender_id"], name: "index_offender_bounties_on_offender_id"
  end

  create_table "offender_bounty_approval_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "approval_id"
    t.bigint "offender_bounty_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_offender_bounty_approval_requests_on_approval_id"
    t.index ["offender_bounty_id"], name: "index_offender_bounty_approval_requests_on_offender_bounty_id"
    t.index ["user_id"], name: "index_offender_bounty_approval_requests_on_user_id"
  end

  create_table "offender_report_approval_requests", force: :cascade do |t|
    t.bigint "offender_report_id"
    t.bigint "approval_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_offender_report_approval_requests_on_approval_id"
    t.index ["offender_report_id"], name: "index_offender_report_approval_requests_on_offender_report_id"
    t.index ["user_id"], name: "index_offender_report_approval_requests_on_user_id"
  end

  create_table "offender_report_force_levels", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offender_report_infractions", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.bigint "violence_rating_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["violence_rating_id"], name: "index_offender_report_infractions_on_violence_rating_id"
  end

  create_table "offender_report_infractions_committeds", force: :cascade do |t|
    t.bigint "infraction_id"
    t.bigint "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["infraction_id"], name: "index_offender_report_infractions_committeds_on_infraction_id"
    t.index ["report_id"], name: "index_offender_report_infractions_committeds_on_report_id"
  end

  create_table "offender_report_offenders", force: :cascade do |t|
    t.text "offender_name"
    t.text "offender_handle"
    t.boolean "offender_handle_verified"
    t.text "offender_rsi_url"
    t.text "offender_rsi_avatar"
    t.integer "offender_citizen_number"
    t.integer "offender_rating_percentage"
    t.bigint "offender_rating_id"
    t.bigint "offender_report_org_id"
    t.integer "offender_org_rank"
    t.text "org_title"
    t.boolean "dont_scrape", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offender_rating_id"], name: "index_offender_report_offenders_on_offender_rating_id"
    t.index ["offender_report_org_id"], name: "index_offender_report_offenders_on_offender_report_org_id"
  end

  create_table "offender_report_orgs", force: :cascade do |t|
    t.text "title"
    t.text "spectrum_id"
    t.text "description"
    t.integer "member_count"
    t.string "model"
    t.string "commitment"
    t.string "primary_activity"
    t.string "secondary_activity"
    t.bigint "violence_rating_id"
    t.text "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["violence_rating_id"], name: "index_offender_report_orgs_on_violence_rating_id"
  end

  create_table "offender_report_violence_ratings", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offender_reports", force: :cascade do |t|
    t.text "description"
    t.boolean "report_approved"
    t.boolean "submitted_for_approval", default: false
    t.bigint "created_by_id"
    t.datetime "occured_when"
    t.bigint "violence_rating_id"
    t.bigint "offender_id"
    t.bigint "ship_id"
    t.uuid "system_id"
    t.uuid "planet_id"
    t.uuid "moon_id"
    t.uuid "system_object_id"
    t.uuid "settlement_id"
    t.uuid "location_id"
    t.bigint "offender_report_approval_request_id"
    t.bigint "force_level_applied_id"
    t.boolean "archived", default: false
    t.bigint "classification_level_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classification_level_id"], name: "index_offender_reports_on_classification_level_id"
    t.index ["created_by_id"], name: "index_offender_reports_on_created_by_id"
    t.index ["force_level_applied_id"], name: "index_offender_reports_on_force_level_applied_id"
    t.index ["location_id"], name: "index_offender_reports_on_location_id"
    t.index ["moon_id"], name: "index_offender_reports_on_moon_id"
    t.index ["offender_id"], name: "index_offender_reports_on_offender_id"
    t.index ["offender_report_approval_request_id"], name: "index_offender_reports_on_offender_report_approval_request_id"
    t.index ["planet_id"], name: "index_offender_reports_on_planet_id"
    t.index ["settlement_id"], name: "index_offender_reports_on_settlement_id"
    t.index ["ship_id"], name: "index_offender_reports_on_ship_id"
    t.index ["system_id"], name: "index_offender_reports_on_system_id"
    t.index ["system_object_id"], name: "index_offender_reports_on_system_object_id"
    t.index ["violence_rating_id"], name: "index_offender_reports_on_violence_rating_id"
  end

  create_table "organization_ship_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "owned_ship_id"
    t.bigint "approval_id"
    t.bigint "division_id"
    t.text "procedures_document_web_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_organization_ship_requests_on_approval_id"
    t.index ["division_id"], name: "index_organization_ship_requests_on_division_id"
    t.index ["owned_ship_id"], name: "index_organization_ship_requests_on_owned_ship_id"
    t.index ["user_id"], name: "index_organization_ship_requests_on_user_id"
  end

  create_table "owned_ship_crew_requests", force: :cascade do |t|
    t.bigint "crew_id"
    t.bigint "approval_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_owned_ship_crew_requests_on_approval_id"
    t.index ["crew_id"], name: "index_owned_ship_crew_requests_on_crew_id"
    t.index ["user_id"], name: "index_owned_ship_crew_requests_on_user_id"
  end

  create_table "owned_ship_crew_roles", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.integer "role_slots"
    t.integer "ordinal"
    t.boolean "recruitable"
    t.boolean "editable", default: true
    t.boolean "is_commander", default: false
    t.bigint "owned_ship_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owned_ship_id"], name: "index_owned_ship_crew_roles_on_owned_ship_id"
  end

  create_table "owned_ship_crews", force: :cascade do |t|
    t.bigint "owned_ship_id"
    t.bigint "crew_role_id"
    t.bigint "character_id"
    t.boolean "request_approved", default: false
    t.boolean "is_backup_crew", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_owned_ship_crews_on_character_id"
    t.index ["crew_role_id"], name: "index_owned_ship_crews_on_crew_role_id"
    t.index ["owned_ship_id"], name: "index_owned_ship_crews_on_owned_ship_id"
  end

  create_table "owned_ships", force: :cascade do |t|
    t.text "title"
    t.bigint "avatar_id"
    t.bigint "character_id"
    t.bigint "ship_id"
    t.bigint "organization_ship_request_id"
    t.decimal "fcr", default: "0.0"
    t.boolean "is_corp_ship", default: false
    t.boolean "hidden", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.index ["avatar_id"], name: "index_owned_ships_on_avatar_id"
    t.index ["character_id"], name: "index_owned_ships_on_character_id"
    t.index ["organization_ship_request_id"], name: "index_owned_ships_on_organization_ship_request_id"
    t.index ["ship_id"], name: "index_owned_ships_on_ship_id"
  end

  create_table "page_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.boolean "featured", default: false
    t.boolean "read_only", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "page_entry_edits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "comment"
    t.uuid "page_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_entry_edits_on_page_id"
    t.index ["user_id"], name: "index_page_entry_edits_on_user_id"
  end

  create_table "page_entry_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "page_id"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_entry_roles_on_page_id"
    t.index ["role_id"], name: "index_page_entry_roles_on_role_id"
  end

  create_table "page_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "page_id"
    t.bigint "image_upload_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_upload_id"], name: "index_page_images_on_image_upload_id"
    t.index ["page_id"], name: "index_page_images_on_page_id"
  end

  create_table "page_in_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "page_id"
    t.uuid "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_page_in_categories_on_category_id"
    t.index ["page_id"], name: "index_page_in_categories_on_page_id"
  end

  create_table "pages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "subtitle"
    t.text "content"
    t.text "tags"
    t.boolean "read_only", default: false
    t.datetime "published_when"
    t.boolean "published", default: false
    t.bigint "creator_id"
    t.bigint "classification_level_id"
    t.boolean "archived", default: false
    t.boolean "is_official", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classification_level_id"], name: "index_pages_on_classification_level_id"
    t.index ["creator_id"], name: "index_pages_on_creator_id"
  end

  create_table "point_transactions", force: :cascade do |t|
    t.integer "amount"
    t.text "reason"
    t.boolean "approved"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_point_transactions_on_user_id"
  end

  create_table "position_change_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "approval_id"
    t.bigint "job_id"
    t.bigint "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_position_change_requests_on_approval_id"
    t.index ["character_id"], name: "index_position_change_requests_on_character_id"
    t.index ["job_id"], name: "index_position_change_requests_on_job_id"
    t.index ["user_id"], name: "index_position_change_requests_on_user_id"
  end

  create_table "report_approval_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "approval_id"
    t.uuid "report_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_report_approval_requests_on_approval_id"
    t.index ["report_id"], name: "index_report_approval_requests_on_report_id"
    t.index ["user_id"], name: "index_report_approval_requests_on_user_id"
  end

  create_table "report_field_values", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "value"
    t.uuid "report_id"
    t.uuid "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "report_fields", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "report_id"
    t.text "name"
    t.text "description"
    t.text "validator"
    t.integer "field_presentation_type_id"
    t.uuid "field_id"
    t.uuid "report_handler_variable_id"
    t.boolean "required"
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_report_fields_on_field_id"
    t.index ["report_handler_variable_id"], name: "index_report_fields_on_report_handler_variable_id"
    t.index ["report_id"], name: "index_report_fields_on_report_id"
  end

  create_table "report_handler_variables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "handler_id"
    t.text "name"
    t.text "object_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["handler_id"], name: "index_report_handler_variables_on_handler_id"
  end

  create_table "report_handlers", force: :cascade do |t|
    t.text "name"
    t.text "for_class"
    t.bigint "approval_kind_id"
    t.boolean "archived", default: false
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_kind_id"], name: "index_report_handlers_on_approval_kind_id"
  end

  create_table "report_routes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.bigint "for_role_id"
    t.bigint "for_user_id"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["for_role_id"], name: "index_report_routes_on_for_role_id"
    t.index ["for_user_id"], name: "index_report_routes_on_for_user_id"
  end

  create_table "report_template_fields", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "template_id"
    t.text "name"
    t.text "description"
    t.text "validator"
    t.integer "field_presentation_type_id"
    t.uuid "field_id"
    t.uuid "report_handler_variable_id"
    t.boolean "required", default: false
    t.integer "ordinal"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_report_template_fields_on_field_id"
    t.index ["report_handler_variable_id"], name: "index_report_template_fields_on_report_handler_variable_id"
    t.index ["template_id"], name: "index_report_template_fields_on_template_id"
  end

  create_table "report_templates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.boolean "draft", default: true
    t.bigint "handler_id"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.bigint "role_id"
    t.uuid "report_for_id"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_report_templates_on_created_by_id"
    t.index ["handler_id"], name: "index_report_templates_on_handler_id"
    t.index ["report_for_id"], name: "index_report_templates_on_report_for_id"
    t.index ["role_id"], name: "index_report_templates_on_role_id"
    t.index ["updated_by_id"], name: "index_report_templates_on_updated_by_id"
  end

  create_table "reports", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "template_id"
    t.text "template_name"
    t.text "template_description"
    t.bigint "handler_id"
    t.bigint "created_by_id"
    t.uuid "report_for_id"
    t.boolean "draft", default: true
    t.boolean "approved", default: false
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_reports_on_created_by_id"
    t.index ["handler_id"], name: "index_reports_on_handler_id"
    t.index ["report_for_id"], name: "index_reports_on_report_for_id"
    t.index ["template_id"], name: "index_reports_on_template_id"
  end

  create_table "research_project_members", force: :cascade do |t|
    t.bigint "research_project_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["research_project_id"], name: "index_research_project_members_on_research_project_id"
    t.index ["user_id"], name: "index_research_project_members_on_user_id"
  end

  create_table "research_project_observation_images", force: :cascade do |t|
    t.bigint "research_project_observation_id"
    t.bigint "image_upload_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_upload_id"], name: "index_research_project_observation_images_on_image_upload_id"
    t.index ["research_project_observation_id"], name: "rp_image_to_project_obj_id"
  end

  create_table "research_project_observations", force: :cascade do |t|
    t.text "title"
    t.text "text"
    t.bigint "research_project_task_id"
    t.bigint "research_project_id"
    t.bigint "created_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_research_project_observations_on_created_by_id"
    t.index ["research_project_id"], name: "index_research_project_observations_on_research_project_id"
    t.index ["research_project_task_id"], name: "ob_to_project_task_id"
  end

  create_table "research_project_requests", force: :cascade do |t|
    t.bigint "research_project_id"
    t.bigint "approval_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_research_project_requests_on_approval_id"
    t.index ["research_project_id"], name: "index_research_project_requests_on_research_project_id"
    t.index ["user_id"], name: "index_research_project_requests_on_user_id"
  end

  create_table "research_project_statuses", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "research_project_task_assignees", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_research_project_task_assignees_on_user_id"
  end

  create_table "research_project_task_statuses", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "research_project_task_types", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "research_project_tasks", force: :cascade do |t|
    t.text "title"
    t.bigint "task_status_id"
    t.bigint "task_type_id"
    t.bigint "research_project_id"
    t.bigint "created_by_id"
    t.boolean "is_archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_research_project_tasks_on_created_by_id"
    t.index ["research_project_id"], name: "index_research_project_tasks_on_research_project_id"
    t.index ["task_status_id"], name: "index_research_project_tasks_on_task_status_id"
    t.index ["task_type_id"], name: "index_research_project_tasks_on_task_type_id"
  end

  create_table "research_project_types", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "research_projects", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.bigint "system_id"
    t.bigint "planet_id"
    t.bigint "moon_id"
    t.bigint "system_object_id"
    t.bigint "location_id"
    t.bigint "research_project_status_id"
    t.bigint "research_project_type_id"
    t.bigint "research_project_request_id"
    t.bigint "project_lead_id"
    t.bigint "created_by_id"
    t.bigint "classification_level_id"
    t.boolean "is_archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classification_level_id"], name: "index_research_projects_on_classification_level_id"
    t.index ["created_by_id"], name: "index_research_projects_on_created_by_id"
    t.index ["location_id"], name: "index_research_projects_on_location_id"
    t.index ["moon_id"], name: "index_research_projects_on_moon_id"
    t.index ["planet_id"], name: "index_research_projects_on_planet_id"
    t.index ["project_lead_id"], name: "index_research_projects_on_project_lead_id"
    t.index ["research_project_request_id"], name: "index_research_projects_on_research_project_request_id"
    t.index ["research_project_status_id"], name: "index_research_projects_on_research_project_status_id"
    t.index ["research_project_type_id"], name: "index_research_projects_on_research_project_type_id"
    t.index ["system_id"], name: "index_research_projects_on_system_id"
    t.index ["system_object_id"], name: "index_research_projects_on_system_object_id"
  end

  create_table "role_removal_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.bigint "approval_id"
    t.bigint "on_behalf_of_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_role_removal_requests_on_approval_id"
    t.index ["on_behalf_of_id"], name: "index_role_removal_requests_on_on_behalf_of_id"
    t.index ["role_id"], name: "index_role_removal_requests_on_role_id"
    t.index ["user_id"], name: "index_role_removal_requests_on_user_id"
  end

  create_table "role_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.bigint "approval_id"
    t.bigint "on_behalf_of_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_role_requests_on_approval_id"
    t.index ["on_behalf_of_id"], name: "index_role_requests_on_on_behalf_of_id"
    t.index ["role_id"], name: "index_role_requests_on_role_id"
    t.index ["user_id"], name: "index_role_requests_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.integer "max_users", default: 0
    t.text "discord_role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rp_news_stories", force: :cascade do |t|
    t.text "title"
    t.text "text"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.boolean "archived", default: false
    t.boolean "published", default: false
    t.boolean "kaiden_announced", default: false
    t.boolean "public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_rp_news_stories_on_created_by_id"
    t.index ["updated_by_id"], name: "index_rp_news_stories_on_updated_by_id"
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string "name", null: false
    t.string "environment"
    t.text "certificate"
    t.string "password"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "auth_key"
    t.string "client_id"
    t.string "client_secret"
    t.string "access_token"
    t.datetime "access_token_expiration"
    t.text "apn_key"
    t.string "apn_key_id"
    t.string "team_id"
    t.string "bundle_id"
    t.boolean "feedback_enabled", default: true
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string "device_token"
    t.datetime "failed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer "badge"
    t.string "device_token"
    t.string "sound"
    t.text "alert"
    t.text "data"
    t.integer "expiry", default: 86400
    t.boolean "delivered", default: false, null: false
    t.datetime "delivered_at"
    t.boolean "failed", default: false, null: false
    t.datetime "failed_at"
    t.integer "error_code"
    t.text "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alert_is_json", default: false, null: false
    t.string "type", null: false
    t.string "collapse_key"
    t.boolean "delay_while_idle", default: false, null: false
    t.text "registration_ids"
    t.integer "app_id", null: false
    t.integer "retries", default: 0
    t.string "uri"
    t.datetime "fail_after"
    t.boolean "processing", default: false, null: false
    t.integer "priority"
    t.text "url_args"
    t.string "category"
    t.boolean "content_available", default: false, null: false
    t.text "notification"
    t.boolean "mutable_content", default: false, null: false
    t.string "external_device_id"
    t.string "thread_id"
    t.boolean "dry_run", default: false, null: false
    t.index ["delivered", "failed", "processing", "deliver_after", "created_at"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))"
  end

  create_table "service_notes", force: :cascade do |t|
    t.text "text"
    t.bigint "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_service_notes_on_character_id"
  end

  create_table "ships", force: :cascade do |t|
    t.text "name"
    t.text "manufacturer"
    t.integer "size"
    t.integer "cargo_capacity", default: 0
    t.integer "crew_size", default: 1
    t.boolean "selectable", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_log_types", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_logs", force: :cascade do |t|
    t.text "module"
    t.text "submodule"
    t.text "message"
    t.bigint "site_log_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_log_type_id"], name: "index_site_logs_on_site_log_type_id"
  end

  create_table "store_cart_items", force: :cascade do |t|
    t.bigint "cart_id"
    t.bigint "item_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_store_cart_items_on_cart_id"
    t.index ["item_id"], name: "index_store_cart_items_on_item_id"
  end

  create_table "store_carts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_store_carts_on_order_id"
    t.index ["user_id"], name: "index_store_carts_on_user_id"
  end

  create_table "store_currency_types", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.string "currency_symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "store_item_categories", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.bigint "creator_id"
    t.bigint "last_updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_store_item_categories_on_creator_id"
    t.index ["last_updated_by_id"], name: "index_store_item_categories_on_last_updated_by_id"
  end

  create_table "store_items", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.decimal "cost", precision: 8, scale: 2
    t.bigint "currency_type_id"
    t.bigint "category_id"
    t.integer "base_stock"
    t.string "size"
    t.boolean "archived", default: false
    t.boolean "show_in_store", default: false
    t.boolean "locked", default: false
    t.decimal "max_shipping_cost", precision: 8, scale: 2
    t.integer "weight"
    t.bigint "creator_id"
    t.bigint "last_updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.index ["category_id"], name: "index_store_items_on_category_id"
    t.index ["creator_id"], name: "index_store_items_on_creator_id"
    t.index ["currency_type_id"], name: "index_store_items_on_currency_type_id"
    t.index ["last_updated_by_id"], name: "index_store_items_on_last_updated_by_id"
  end

  create_table "store_order_statuses", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.boolean "can_select", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "store_orders", force: :cascade do |t|
    t.bigint "cart_id"
    t.bigint "status_id"
    t.text "stripe_transaction_id"
    t.text "stripe_refund_id"
    t.bigint "point_transaction_id"
    t.boolean "payment_processed"
    t.boolean "refund_issued", default: false
    t.text "tracking_number"
    t.decimal "added_shipping_cost", precision: 8, scale: 2
    t.bigint "assigned_to_id"
    t.bigint "last_updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_store_orders_on_assigned_to_id"
    t.index ["cart_id"], name: "index_store_orders_on_cart_id"
    t.index ["last_updated_by_id"], name: "index_store_orders_on_last_updated_by_id"
    t.index ["point_transaction_id"], name: "index_store_orders_on_point_transaction_id"
    t.index ["status_id"], name: "index_store_orders_on_status_id"
  end

  create_table "system_map_atmo_compositions", force: :cascade do |t|
    t.bigint "atmo_gas_id"
    t.bigint "for_planet_id"
    t.bigint "for_moon_id"
    t.bigint "for_system_object_id"
    t.decimal "percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["atmo_gas_id"], name: "index_system_map_atmo_compositions_on_atmo_gas_id"
    t.index ["for_moon_id"], name: "index_system_map_atmo_compositions_on_for_moon_id"
    t.index ["for_planet_id"], name: "index_system_map_atmo_compositions_on_for_planet_id"
    t.index ["for_system_object_id"], name: "index_system_map_atmo_compositions_on_for_system_object_id"
  end

  create_table "system_map_atmo_gases", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.boolean "toxic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_map_faunas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.boolean "is_predator"
    t.boolean "is_sentient"
    t.integer "density"
    t.uuid "on_moon_id"
    t.uuid "on_planet_id"
    t.uuid "on_system_object_id"
    t.bigint "discovered_by_id"
    t.uuid "primary_image_id"
    t.bigint "classification_level_id"
    t.boolean "approved", default: true
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discovered_by_id"], name: "index_system_map_faunas_on_discovered_by_id"
    t.index ["on_moon_id"], name: "index_system_map_faunas_on_on_moon_id"
    t.index ["on_planet_id"], name: "index_system_map_faunas_on_on_planet_id"
    t.index ["on_system_object_id"], name: "index_system_map_faunas_on_on_system_object_id"
    t.index ["primary_image_id"], name: "index_system_map_faunas_on_primary_image_id"
  end

  create_table "system_map_floras", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.boolean "is_predator"
    t.boolean "is_toxic"
    t.boolean "is_sentient"
    t.integer "density"
    t.uuid "on_moon_id"
    t.uuid "on_planet_id"
    t.uuid "on_system_object_id"
    t.bigint "discovered_by_id"
    t.uuid "primary_image_id"
    t.bigint "classification_level_id"
    t.boolean "approved", default: true
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discovered_by_id"], name: "index_system_map_floras_on_discovered_by_id"
    t.index ["on_moon_id"], name: "index_system_map_floras_on_on_moon_id"
    t.index ["on_planet_id"], name: "index_system_map_floras_on_on_planet_id"
    t.index ["on_system_object_id"], name: "index_system_map_floras_on_on_system_object_id"
    t.index ["primary_image_id"], name: "index_system_map_floras_on_primary_image_id"
  end

  create_table "system_map_images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.bigint "created_by_id"
    t.boolean "is_default_image", default: false
    t.uuid "of_system_id"
    t.uuid "of_planet_id"
    t.uuid "of_moon_id"
    t.uuid "of_system_object_id"
    t.uuid "of_location_id"
    t.uuid "of_settlement_id"
    t.uuid "of_gravity_well_id"
    t.uuid "of_mission_giver_id"
    t.uuid "of_connection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.index ["created_by_id"], name: "index_system_map_images_on_created_by_id"
    t.index ["of_connection_id"], name: "index_system_map_images_on_of_connection_id"
    t.index ["of_gravity_well_id"], name: "index_system_map_images_on_of_gravity_well_id"
    t.index ["of_location_id"], name: "index_system_map_images_on_of_location_id"
    t.index ["of_mission_giver_id"], name: "index_system_map_images_on_of_mission_giver_id"
    t.index ["of_moon_id"], name: "index_system_map_images_on_of_moon_id"
    t.index ["of_planet_id"], name: "index_system_map_images_on_of_planet_id"
    t.index ["of_settlement_id"], name: "index_system_map_images_on_of_settlement_id"
    t.index ["of_system_id"], name: "index_system_map_images_on_of_system_id"
    t.index ["of_system_object_id"], name: "index_system_map_images_on_of_system_object_id"
  end

  create_table "system_map_mission_givers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.bigint "discovered_by_id"
    t.uuid "primary_image_id"
    t.bigint "classification_level_id"
    t.uuid "faction_affiliation_id"
    t.uuid "on_system_object_id"
    t.uuid "on_settlement_id"
    t.uuid "on_location_id"
    t.boolean "approved", default: true
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classification_level_id"], name: "index_system_map_mission_givers_on_classification_level_id"
    t.index ["discovered_by_id"], name: "index_system_map_mission_givers_on_discovered_by_id"
    t.index ["faction_affiliation_id"], name: "index_system_map_mission_givers_on_faction_affiliation_id"
    t.index ["on_location_id"], name: "index_system_map_mission_givers_on_on_location_id"
    t.index ["on_settlement_id"], name: "index_system_map_mission_givers_on_on_settlement_id"
    t.index ["on_system_object_id"], name: "index_system_map_mission_givers_on_on_system_object_id"
    t.index ["primary_image_id"], name: "index_system_map_mission_givers_on_primary_image_id"
  end

  create_table "system_map_system_connections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.uuid "connection_size_id"
    t.uuid "connection_status_id"
    t.uuid "system_one_id"
    t.uuid "system_two_id"
    t.bigint "primary_image_one_id"
    t.bigint "primary_image_two_id"
    t.bigint "classification_level_id"
    t.bigint "discovered_by_id"
    t.boolean "approved", default: true
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["connection_size_id"], name: "conn_size_id"
    t.index ["connection_status_id"], name: "conn_size_status"
    t.index ["discovered_by_id"], name: "index_system_map_system_connections_on_discovered_by_id"
    t.index ["primary_image_one_id"], name: "index_system_map_system_connections_on_primary_image_one_id"
    t.index ["primary_image_two_id"], name: "index_system_map_system_connections_on_primary_image_two_id"
    t.index ["system_one_id"], name: "index_system_map_system_connections_on_system_one_id"
    t.index ["system_two_id"], name: "index_system_map_system_connections_on_system_two_id"
  end

  create_table "system_map_system_gravity_wells", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.boolean "approved", default: true
    t.uuid "system_id"
    t.uuid "gravity_well_type_id"
    t.uuid "luminosity_class_id"
    t.bigint "discovered_by_id"
    t.bigint "primary_image_id"
    t.boolean "discovered"
    t.boolean "archived", default: false
    t.bigint "classification_level_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discovered_by_id"], name: "index_system_map_system_gravity_wells_on_discovered_by_id"
    t.index ["gravity_well_type_id"], name: "index_system_map_system_gravity_wells_on_gravity_well_type_id"
    t.index ["luminosity_class_id"], name: "index_system_map_system_gravity_wells_on_luminosity_class_id"
    t.index ["primary_image_id"], name: "index_system_map_system_gravity_wells_on_primary_image_id"
    t.index ["system_id"], name: "index_system_map_system_gravity_wells_on_system_id"
  end

  create_table "system_map_system_objects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.boolean "approved", default: true
    t.uuid "object_type_id"
    t.uuid "orbits_system_id"
    t.uuid "orbits_planet_id"
    t.uuid "orbits_moon_id"
    t.bigint "discovered_by_id"
    t.boolean "discovered"
    t.boolean "archived", default: false
    t.boolean "atmosphere_present"
    t.boolean "atmosphere_human_breathable"
    t.float "atmo_pressure"
    t.float "population_density"
    t.float "economic_rating"
    t.float "general_radiation"
    t.integer "minimum_criminality_rating"
    t.text "semi_major_axis"
    t.text "apoapsis"
    t.text "periapsis"
    t.text "orbital_eccentricity"
    t.text "orbital_inclination"
    t.text "argument_of_periapsis"
    t.text "longitude_of_the_ascending_node"
    t.text "mean_anomaly"
    t.text "sidereal_orbital_period"
    t.text "synodic_orbital_period"
    t.text "orbital_velocity"
    t.bigint "jurisdiction_id"
    t.uuid "faction_affiliation_id"
    t.bigint "classification_level_id"
    t.uuid "primary_image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discovered_by_id"], name: "index_system_map_system_objects_on_discovered_by_id"
    t.index ["faction_affiliation_id"], name: "index_system_map_system_objects_on_faction_affiliation_id"
    t.index ["jurisdiction_id"], name: "index_system_map_system_objects_on_jurisdiction_id"
    t.index ["object_type_id"], name: "index_system_map_system_objects_on_object_type_id"
    t.index ["orbits_moon_id"], name: "index_system_map_system_objects_on_orbits_moon_id"
    t.index ["orbits_planet_id"], name: "index_system_map_system_objects_on_orbits_planet_id"
    t.index ["orbits_system_id"], name: "index_system_map_system_objects_on_orbits_system_id"
    t.index ["primary_image_id"], name: "index_system_map_system_objects_on_primary_image_id"
  end

  create_table "system_map_system_planetary_bodies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.bigint "orbits_system_id"
    t.bigint "discovered_by_id"
    t.uuid "faction_affiliation_id"
    t.uuid "safety_rating_id"
    t.boolean "discovered"
    t.boolean "archived", default: false
    t.boolean "approved", default: true
    t.boolean "atmosphere_present"
    t.boolean "atmosphere_human_breathable"
    t.integer "atmospheric_height"
    t.float "atmo_pressure"
    t.boolean "surface_hazards"
    t.float "tempature_max"
    t.float "tempature_min"
    t.float "solar_day"
    t.float "population_density"
    t.float "economic_rating"
    t.float "general_radiation"
    t.integer "minimum_criminality_rating"
    t.text "semi_major_axis"
    t.text "apoapsis"
    t.text "periapsis"
    t.text "orbital_eccentricity"
    t.text "orbital_inclination"
    t.text "argument_of_periapsis"
    t.text "longitude_of_the_ascending_node"
    t.text "mean_anomaly"
    t.text "sidereal_orbital_period"
    t.text "synodic_orbital_period"
    t.text "orbital_velocity"
    t.text "surface_gravity"
    t.text "escape_velocity"
    t.text "mass"
    t.bigint "jurisdiction_id"
    t.bigint "classification_level_id"
    t.bigint "primary_image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discovered_by_id"], name: "index_system_map_system_planetary_bodies_on_discovered_by_id"
    t.index ["faction_affiliation_id"], name: "planet_faction_id"
    t.index ["jurisdiction_id"], name: "planet_juristiction_id"
    t.index ["orbits_system_id"], name: "orbits_system_id"
    t.index ["primary_image_id"], name: "planet_primary_image"
    t.index ["safety_rating_id"], name: "index_system_map_system_planetary_bodies_on_safety_rating_id"
  end

  create_table "system_map_system_planetary_body_locations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.boolean "approved", default: true
    t.text "coordinates"
    t.float "long"
    t.float "lat"
    t.bigint "location_type_id"
    t.uuid "on_moon_id"
    t.uuid "on_planet_id"
    t.uuid "on_system_object_id"
    t.uuid "on_settlement_id"
    t.uuid "faction_affiliation_id"
    t.integer "minimum_criminality_rating"
    t.bigint "discovered_by_id"
    t.bigint "classification_level_id"
    t.uuid "primary_image_id"
    t.boolean "discovered"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discovered_by_id"], name: "location_discovered_by_id"
    t.index ["faction_affiliation_id"], name: "location_faction_id"
    t.index ["location_type_id"], name: "location_type_id"
    t.index ["on_moon_id"], name: "on_moon_id"
    t.index ["on_planet_id"], name: "on_planet_id"
    t.index ["on_system_object_id"], name: "on_system_object_in_id"
    t.index ["primary_image_id"], name: "location_primary_image"
  end

  create_table "system_map_system_planetary_body_moons", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.bigint "orbits_planet_id"
    t.bigint "discovered_by_id"
    t.uuid "faction_affiliation_id"
    t.boolean "discovered"
    t.boolean "archived", default: false
    t.boolean "approved", default: true
    t.boolean "atmosphere_present"
    t.boolean "atmosphere_human_breathable"
    t.integer "atmospheric_height"
    t.float "atmo_pressure"
    t.boolean "surface_hazards"
    t.float "tempature_max"
    t.float "tempature_min"
    t.float "solar_day"
    t.float "population_density"
    t.float "economic_rating"
    t.float "general_radiation"
    t.integer "minimum_criminality_rating"
    t.text "semi_major_axis"
    t.text "apoapsis"
    t.text "periapsis"
    t.text "orbital_eccentricity"
    t.text "orbital_inclination"
    t.text "argument_of_periapsis"
    t.text "longitude_of_the_ascending_node"
    t.text "mean_anomaly"
    t.text "sidereal_orbital_period"
    t.text "synodic_orbital_period"
    t.text "orbital_velocity"
    t.text "surface_gravity"
    t.text "escape_velocity"
    t.text "mass"
    t.bigint "jurisdiction_id"
    t.bigint "classification_level_id"
    t.bigint "primary_image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discovered_by_id"], name: "moon_discovered_by_id"
    t.index ["jurisdiction_id"], name: "moon_juristiction_id"
    t.index ["orbits_planet_id"], name: "orbits_planet_id"
    t.index ["primary_image_id"], name: "moon_primary_image"
  end

  create_table "system_map_system_settlements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.text "coordinates"
    t.boolean "approved", default: true
    t.boolean "archived", default: false
    t.uuid "faction_affiliation_id"
    t.uuid "safety_rating_id"
    t.uuid "on_planet_id"
    t.uuid "on_moon_id"
    t.uuid "primary_image_id"
    t.bigint "discovered_by_id"
    t.integer "minimum_criminality_rating"
    t.bigint "jurisdiction_id"
    t.bigint "classification_level_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classification_level_id"], name: "index_system_map_system_settlements_on_classification_level_id"
    t.index ["discovered_by_id"], name: "index_system_map_system_settlements_on_discovered_by_id"
    t.index ["faction_affiliation_id"], name: "index_system_map_system_settlements_on_faction_affiliation_id"
    t.index ["jurisdiction_id"], name: "index_system_map_system_settlements_on_jurisdiction_id"
    t.index ["on_moon_id"], name: "index_system_map_system_settlements_on_on_moon_id"
    t.index ["on_planet_id"], name: "index_system_map_system_settlements_on_on_planet_id"
    t.index ["primary_image_id"], name: "index_system_map_system_settlements_on_primary_image_id"
    t.index ["safety_rating_id"], name: "index_system_map_system_settlements_on_safety_rating_id"
  end

  create_table "system_map_systems", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "tags"
    t.boolean "approved", default: true
    t.bigint "discovered_by_id"
    t.uuid "faction_affiliation_id"
    t.boolean "discovered"
    t.boolean "archived", default: false
    t.bigint "jurisdiction_id"
    t.bigint "classification_level_id"
    t.uuid "primary_image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discovered_by_id"], name: "index_system_map_systems_on_discovered_by_id"
    t.index ["faction_affiliation_id"], name: "index_system_map_systems_on_faction_affiliation_id"
    t.index ["jurisdiction_id"], name: "index_system_map_systems_on_jurisdiction_id"
    t.index ["primary_image_id"], name: "index_system_map_systems_on_primary_image_id"
  end

  create_table "task_logs", force: :cascade do |t|
    t.text "task_id"
    t.text "task_title"
    t.text "message"
    t.boolean "task_succeeded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_managers", force: :cascade do |t|
    t.text "task_name"
    t.boolean "enabled", default: true
    t.boolean "running_now", default: false
    t.datetime "last_run"
    t.datetime "next_run"
    t.integer "recur"
    t.integer "every"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trade_calculation_transactions", force: :cascade do |t|
    t.bigint "trade_calculation_id"
    t.bigint "trade_item_id"
    t.integer "buy_quantity"
    t.integer "sell_quantity"
    t.bigint "trade_item_value_buy_id"
    t.bigint "trade_item_value_sell_id"
    t.bigint "is_finalized_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_finalized_id"], name: "index_trade_calculation_transactions_on_is_finalized_id"
    t.index ["trade_calculation_id"], name: "index_trade_calculation_transactions_on_trade_calculation_id"
    t.index ["trade_item_id"], name: "index_trade_calculation_transactions_on_trade_item_id"
    t.index ["trade_item_value_buy_id"], name: "trade_trans_value_buy_id"
    t.index ["trade_item_value_sell_id"], name: "trade_trans_value_sell_id"
  end

  create_table "trade_calculations", force: :cascade do |t|
    t.bigint "from_system_id"
    t.bigint "to_system_id"
    t.bigint "owned_ship_id"
    t.bigint "safety_rating_id"
    t.bigint "classification_level_id"
    t.bigint "user_id"
    t.boolean "is_finalized", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classification_level_id"], name: "index_trade_calculations_on_classification_level_id"
    t.index ["from_system_id"], name: "index_trade_calculations_on_from_system_id"
    t.index ["owned_ship_id"], name: "index_trade_calculations_on_owned_ship_id"
    t.index ["safety_rating_id"], name: "index_trade_calculations_on_safety_rating_id"
    t.index ["to_system_id"], name: "index_trade_calculations_on_to_system_id"
    t.index ["user_id"], name: "index_trade_calculations_on_user_id"
  end

  create_table "trade_item_containers", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.decimal "scu"
    t.decimal "width"
    t.decimal "height"
    t.decimal "depth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trade_item_in_calculations", force: :cascade do |t|
    t.bigint "trade_item_id"
    t.bigint "trade_calculation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trade_calculation_id"], name: "index_trade_item_in_calculations_on_trade_calculation_id"
    t.index ["trade_item_id"], name: "index_trade_item_in_calculations_on_trade_item_id"
  end

  create_table "trade_item_types", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trade_item_values", force: :cascade do |t|
    t.decimal "buy_price"
    t.decimal "sell_price"
    t.bigint "location_id"
    t.bigint "trade_item_id"
    t.bigint "added_by_id"
    t.boolean "is_ignored", default: false
    t.boolean "is_finalized"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["added_by_id"], name: "index_trade_item_values_on_added_by_id"
    t.index ["location_id"], name: "index_trade_item_values_on_location_id"
    t.index ["trade_item_id"], name: "index_trade_item_values_on_trade_item_id"
  end

  create_table "trade_items", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.boolean "resellable"
    t.decimal "unit_to_ccu"
    t.integer "item_size"
    t.decimal "average_sell_price", precision: 10, scale: 2
    t.decimal "average_buy_price", precision: 10, scale: 2
    t.bigint "trade_item_container_id"
    t.bigint "best_sell_value_id"
    t.bigint "worst_sell_value_id"
    t.bigint "best_buy_value_id"
    t.bigint "worst_buy_value_id"
    t.bigint "trade_item_type_id"
    t.boolean "is_ignored", default: false
    t.bigint "added_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["added_by_id"], name: "index_trade_items_on_added_by_id"
    t.index ["best_buy_value_id"], name: "index_trade_items_on_best_buy_value_id"
    t.index ["best_sell_value_id"], name: "index_trade_items_on_best_sell_value_id"
    t.index ["trade_item_container_id"], name: "index_trade_items_on_trade_item_container_id"
    t.index ["trade_item_type_id"], name: "index_trade_items_on_trade_item_type_id"
    t.index ["worst_buy_value_id"], name: "index_trade_items_on_worst_buy_value_id"
    t.index ["worst_sell_value_id"], name: "index_trade_items_on_worst_sell_value_id"
  end

  create_table "training_course_assigneds", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "training_course_id"
    t.bigint "assigned_by_id"
    t.datetime "due_date"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_by_id"], name: "index_training_course_assigneds_on_assigned_by_id"
    t.index ["training_course_id"], name: "index_training_course_assigneds_on_training_course_id"
    t.index ["user_id"], name: "index_training_course_assigneds_on_user_id"
  end

  create_table "training_course_completions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "training_course_id"
    t.integer "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["training_course_id"], name: "index_training_course_completions_on_training_course_id"
    t.index ["user_id"], name: "index_training_course_completions_on_user_id"
  end

  create_table "training_courses", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.bigint "badge_id"
    t.bigint "created_by_id"
    t.integer "version"
    t.boolean "draft", default: true
    t.boolean "required", default: false
    t.integer "required_for_division"
    t.boolean "approval_required", default: false
    t.boolean "instructor_required", default: false
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_training_courses_on_badge_id"
    t.index ["created_by_id"], name: "index_training_courses_on_created_by_id"
  end

  create_table "training_item_completion_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "approval_id"
    t.bigint "training_item_completion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approval_id"], name: "index_training_item_completion_requests_on_approval_id"
    t.index ["training_item_completion_id"], name: "request_to_completion_training_item"
    t.index ["user_id"], name: "index_training_item_completion_requests_on_user_id"
  end

  create_table "training_item_completions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "training_item_id"
    t.integer "item_version"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["training_item_id"], name: "completion_to_training_item"
    t.index ["training_item_id"], name: "index_training_item_completions_on_training_item_id"
    t.index ["user_id"], name: "index_training_item_completions_on_user_id"
  end

  create_table "training_item_types", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "training_items", force: :cascade do |t|
    t.bigint "training_course_id"
    t.bigint "training_item_type_id"
    t.bigint "created_by_id"
    t.text "title"
    t.text "text"
    t.text "link"
    t.text "video_link"
    t.text "syllabus_link"
    t.boolean "archived", default: false
    t.integer "version"
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_training_items_on_created_by_id"
    t.index ["training_course_id"], name: "index_training_items_on_training_course_id"
    t.index ["training_item_type_id"], name: "index_training_items_on_training_item_type_id"
  end

  create_table "user_account_types", force: :cascade do |t|
    t.text "title"
    t.integer "ordinal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_countries", force: :cascade do |t|
    t.text "code"
    t.text "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_device_types", force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_informations", force: :cascade do |t|
    t.text "first_name"
    t.text "last_name"
    t.text "street_address"
    t.text "city"
    t.text "state"
    t.text "zip"
    t.bigint "country_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_user_informations_on_country_id"
    t.index ["user_id"], name: "index_user_informations_on_user_id"
  end

  create_table "user_push_tokens", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "user_device_type_id"
    t.text "token"
    t.boolean "active", default: true
    t.text "reg_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_device_type_id"], name: "index_user_push_tokens_on_user_device_type_id"
    t.index ["user_id"], name: "index_user_push_tokens_on_user_id"
  end

  create_table "user_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id"
    t.text "ip_address"
    t.float "longitude"
    t.float "latitude"
    t.text "location"
    t.text "country_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "user_settings", force: :cascade do |t|
    t.boolean "notify_for_new_messages", default: true
    t.boolean "notify_for_new_events", default: true
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_settings_on_user_id"
  end

  create_table "user_tokens", force: :cascade do |t|
    t.bigint "user_id"
    t.text "token"
    t.datetime "expires"
    t.text "device"
    t.text "ip_address"
    t.float "longitude"
    t.float "latitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "username"
    t.text "email"
    t.text "password_digest"
    t.text "auth_secret"
    t.boolean "use_two_factor", default: false
    t.integer "login_attempts", default: 0
    t.boolean "locked", default: false
    t.boolean "login_allowed", default: true
    t.text "verification_string"
    t.boolean "email_verified", default: false
    t.text "password_reset_token"
    t.boolean "password_reset_requested", default: false
    t.bigint "user_account_type_id", default: 1
    t.text "rsi_handle"
    t.text "state"
    t.text "country"
    t.text "auth_token"
    t.boolean "is_member", default: false
    t.boolean "is_admin", default: false
    t.boolean "is_subscriber", default: false
    t.text "subscriber_account_id"
    t.text "subscriber_subscription_id"
    t.boolean "is_online", default: false
    t.boolean "removal_warned", default: false
    t.boolean "discord_link_required", default: true
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_account_type_id"], name: "index_users_on_user_account_type_id"
  end

end
