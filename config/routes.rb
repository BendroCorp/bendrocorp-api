Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #  First route is the root route
  root 'pages#hello'

  # Authenticate a user
  post 'auth' => 'sessions#auth'

  # account routes
  post 'api/account/change-password' => 'account#change_password'
  get 'api/account/fetch-tfa' => 'account#fetch_two_factor_auth'
  post 'api/account/enable-tfa' => 'account#enable_two_factor_auth'

  # admin
  get 'api/admin/users' => 'admin#fetch_users'
  get 'api/admin/approval-kinds' => 'admin#fetch_approval_kinds'
  get 'api/admin/impersonate/:impersonate_user_id' => 'admin#impersonate'

  # Alerts
  get 'api/alert' => 'alerts#list'
  post 'api/alert' => 'alerts#create'
  patch 'api/alert/:alert_id' => 'alerts#update'
  delete 'api/alert/:alert_id' => 'alerts#archive'

  # applications
  post 'api/apply' => 'applications#create'
  get 'api/apply' => 'applications#fetch'
  patch 'api/apply' => 'applications#update_interview'
  delete 'api/apply' => 'applications#withdraw_application'
  get 'api/apply/:character_id/advance' => 'applications#advance_application_status'
  get 'api/apply/:character_id/reject' => 'applications#reject_application'

  # approval Kinds
  get 'api/approval-kinds' => 'approval_kind#list'

  # approvals controller
  get 'api/approval/types' => 'approvals#approval_types'
  get 'api/approvals/:approval_id/:approval_type' => 'approvals#approval_request'
  
  # awards
  get 'api/award' => 'awards#list'
  post 'api/award' => 'awards#create'
  patch 'api/award/:award_id' => 'awards#update'
  delete 'api/award/:award_id' => 'awards#archive'

  # commodities
  get 'api/tools/commodities/' => 'commodities#list'
  post 'api/tools/commodities/' => 'commodities#create'
  patch 'api/tools/commodities/:ti_id' => 'commodities#update'
  delete 'api/tools/commodities/:ti_id' => 'commodities#destroy'
  post 'api/tools/commodities/:ti_id/value' => 'commodities#add_value'
  patch 'api/tools/commodities/:ti_id/value' => 'commodities#update_value'
  get 'api/tools/commodities/:ti_id/value/:trade_value_id' => 'commodities#destroy_value'

  # divisions
  get 'api/divisions' => 'divisions#list'

  # events
  get 'api/events' => 'events#list'
  get 'api/events/expired' => 'events#list_expired'
  get 'api/events/expired/:count' => 'events#list_expired'
  post 'api/events' => 'events#create'
  patch 'api/events' => 'events#update'
  post 'api/events/publish' => 'events#publish'
  post 'api/events/unpublish' => 'events#unpublish'
  post 'api/events/award' => 'events#event_award'
  patch 'api/events/briefing' => 'events#event_briefing_update'
  patch 'api/events/debriefing' => 'events#event_briefing_update'
  post 'api/events/attend' => 'events#set_attendence'
  get 'api/events/types' => 'events#get_types'
  get 'api/events/attendence-types' => 'events#get_attendence_types'
  get 'api/events/:event_id/certify' => 'events#certify_event_attendence'
  post 'api/events/:event_id/certify' => 'events#certify_event_attendence_post'
  get 'api/events/:event_id' => 'events#show'

  # flight Logs
  get 'api/flight-logs' => 'flight_logs#list'
  get 'api/flight-logs/ships' => 'flight_logs#list_ships'
  get 'api/flight-logs/:flight_log_id' => 'flight_logs#show'
  post 'api/flight-logs' => 'flight_logs#create'
  put 'api/flight-logs' => 'flight_logs#update'
  patch 'api/flight-logs' => 'flight_logs#update'
  delete 'api/flight-logs/:flight_log_id' => 'flight_logs#delete'

  # job Board
  get 'api/job-board/' => 'job_board#list'
  get 'api/job-board/types' => 'job_board#list_types'
  post 'api/job-board/' => 'job_board#create'
  patch 'api/job-board/' => 'job_board#update'
  delete 'api/job-board/:mission_id/' => 'job_board#delete'
  post 'api/job-board/accept' => 'job_board#accept_mission'
  post 'api/job-board/abandon' => 'job_board#abandon_mission'
  post 'api/job-board/complete' => 'job_board#complete_mission'

  # 'jobs' (as in employment ops)
  get 'api/job' => 'jobs#list'
  get 'api/job/hiring' => 'jobs#list_hiring'

  # menu items
  get 'api/menu' => 'menu_items#list'
  post 'api/menu' => 'menu_items#create'
  patch 'api/menu' => 'menu_items#update'
  delete 'api/menu/:menu_item_id' => 'menu_items#delete'

  # offender reports
  get 'api/offender-report' => 'offender_reports#list'
  get 'api/offender-report/types' => 'offender_reports#list_types'
  get 'api/offender-report/mine' => 'offender_reports#list_mine'
  get 'api/offender-report/admin' => 'offender_reports#list_admin'
  post 'api/offender-report/submit' => 'offender_reports#submit'
  get 'api/offender-report/:report_id' => 'offender_reports#fetch'
  post 'api/offender-report' => 'offender_reports#create'
  patch 'api/offender-report' => 'offender_reports#update'

  # page entries
  get 'api/pages' => 'page_entries#list'
  post 'api/pages' => 'page_entries#create_page'
  patch 'api/pages' => 'page_entries#update_page'
  delete 'api/pages/:page_id' => 'page_entries#delete_page'
  post 'api/pages/publish' => 'page_entries#publish'
  post 'api/pages/unpublish' => 'page_entries#unpublish'
  post 'api/pages/add-role' => 'page_entries#add_role'
  post 'api/pages/remove-role' => 'page_entries#remove_role'
  get 'api/pages/category' => 'page_entries#fetch_categories'
  post 'api/pages/category' => 'page_entries#update_category'
  patch 'api/pages/category' => 'page_entries#update_category'
  get 'api/pages/category/:page_category_id' => 'page_entries#delete_category'

  # profiles
  get 'api/profile' => 'profiles#list'
  get 'api/profile/by-group' => 'profiles#list_groups'
  get 'api/profile/not-grouped' => 'profiles#list_not_grouped'
  get 'api/profile/by-division' => 'profiles#list_by_divsion'
  patch 'api/profile/avatar' => 'profiles#update_avatar'
  post 'api/profile/ship' => 'profiles#add_ship'
  patch 'api/profile/ship' => 'profiles#update_ship'
  delete 'api/profile/ship/:owned_ship_id' => 'profiles#remove_ship'
  post 'api/profile/comment' => 'profiles#add_application_comment'
  # keep these at the bottom of the profile list
  get 'api/profile/:profile_id' => 'profiles#show'
  patch 'api/profile' => 'profiles#update'


  # reports
  get 'api/report' => 'reports#list'
  get 'api/report/my' => 'reports#list_my'
  post 'api/report' => 'reports#create'
  patch 'api/report' => 'reports#update'
  delete 'api/report/:report_id' => 'reports#delete'
  post 'api/report/submit' => 'reports#submit_for_approval'
  get 'api/report/types' => 'reports#fetch_types'

  # roles
  get 'api/role' => 'roles#list'
  get 'api/role/admin' => 'roles#admin_fetch_roles'
  post 'api/role' => 'roles#create'
  patch 'api/role' => 'roles#update'
  post 'api/role/nest' => 'roles#create_nested_role'
  delete 'api/role/nest/:nested_role_id' => 'roles#delete_nested_role'

  # ships
  get 'api/ship' => 'ships#list'
  get 'api/ship/owned/:owned_ship_id' => 'ships#fetch'
  post 'api/ship/owned' => 'ships#create_owned_ship'
  patch 'api/ship/owned' => 'ships#update_owned_ship'
  delete 'api/ship/owned/:owned_ship_id' => 'ships#delete_owned_ship'
  post 'api/ship/owned/:owned_ship_id/avatar' => 'ships#change_avatar'
  post 'api/ship/owned/:owned_ship_id/crew' => 'ships#crew_position_create'
  get 'api/ship/owned/:owned_ship_id/crew' => 'ships#crew_position_update'
  delete 'api/ship/owned/:owned_ship_id/crew/:crew_position_id' => 'ships#crew_position_delete'
  delete 'api/ship/owned/:owned_ship_id/crew-member/:crew_member_id' => 'ships#remove_from_crew_position'

  # sign ups
  post 'api/signup' => 'signups#create'
  post 'api/verification' => 'signups#resend_verification'
  post 'api/verify/:id' => 'signups#verify'

  # site requests
  post 'api/requests/add-role' => 'site_requests#add_role_post'
  post 'api/requests/remove-role' => 'site_requests#remove_role_post'
  post 'api/requests/award-request' => 'site_requests#add_award_post'
  post 'api/requests/position-change' => 'site_requests#position_change_post'
  post 'api/requests/organization-ship' => 'site_requests#add_organization_ship_post'
  get 'api/requests/crew' => 'site_requests#ship_crew_request'
  post 'api/requests/crew' => 'site_requests#ship_crew_request_post'
  get 'api/requests/job-creation' => 'site_requests#job_creation'
  post 'api/requests/job-creation' => 'site_requests#job_creation_post'
  # # TODO: re add system map requests
  get 'api/approvals/:approval_id' => 'site_requests#approval_details'

  get 'api/approvals/:approval_id/:approval_type' => 'approvals#approval_request'

  # system map routes
  get 'api/system-map' => 'system_map#list'
  post 'api/system-map/planet' => 'system_map#add_planet'
  patch 'api/system-map/planet' => 'system_map#update_planet'
  delete 'api/system-map/planet/:planet_id' => 'system_map#delete_planet'

  post 'api/system-map/moon' => 'system_map#add_moon'
  patch 'api/system-map/moon' => 'system_map#update_moon'
  delete 'api/system-map/moon/:moon_id' => 'system_map#delete_moon'

  post 'api/system-map/system-object' => 'system_map#add_system_object'
  patch 'api/system-map/system-object' => 'system_map#update_system_object'
  delete 'api/system-map/system-object/:so_id' => 'system_map#delete_system_object'

  # users
  get 'api/user' => 'users#list'
  get 'api/user/me' => 'users#me'
  get 'api/user/approvals' => 'users#approvals'
  get 'api/user/approvals-count' => 'users#approvals_count'
  get 'api/user/oauth-tokens' => 'users#oauth_tokens'
  post 'api/user/push-token' => 'users#add_push_token'
  get 'api/user/push' => 'users#push_self'

  # oauth
  post 'api/oauth-client-check' => 'oauth#client_check'
  post 'api/oauth-token' => 'oauth#oauth_post'
  delete 'api/oauth-token/:token' => 'oauth#remove_token'

  # All other routes go above here
  # This two routes should always be at the bottom of the list of routes
	match '*any' => 'application#options', :via => [:options]
	match "*path", to: "pages#not_found", via: :all
end
