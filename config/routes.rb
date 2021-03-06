Rails.application.routes.draw do
  # resources :intelligence_warrants
  # resources :incident_reports
  # resources :intelligence_cases
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Mount action cable
  mount ActionCable.server => '/cable'

  #  First route is the root route
  root 'pages#hello'

  # Authenticate a user
  post 'auth' => 'sessions#auth'

  # user info
  # get 'userinfo' => 'users#me'

  # account routes
  post 'api/account/change-password' => 'account#change_password'
  get 'api/account/fetch-tfa' => 'account#fetch_two_factor_auth'
  post 'api/account/enable-tfa' => 'account#enable_two_factor_auth'
  post 'api/account/forgot-password' => 'account#forgot_password'
  post 'api/account/reset-password' => 'account#forgot_password_complete'
  post 'api/account/update-email' => 'account#update_email'
  delete 'api/account/token/:token' => 'account#remove_user_token'

  # admin
  get 'api/admin/users' => 'admin#fetch_users'
  get 'api/admin/approval-kinds' => 'admin#fetch_approval_kinds'
  get 'api/admin/impersonate/:impersonate_user_id' => 'admin#impersonate'

  # Alerts
  get 'api/alert' => 'alerts#list'
  get 'api/alert/:id' => 'alerts#show'
  post 'api/alert' => 'alerts#create'
  put 'api/alert/' => 'alerts#update'
  delete 'api/alert/:id' => 'alerts#archive'

  # applications
  post 'api/apply' => 'applications#create'
  get 'api/apply' => 'applications#fetch'
  patch 'api/apply' => 'applications#update_interview'
  delete 'api/apply' => 'applications#withdraw_application'
  post 'api/apply/reject' => 'applications#reject_application'
  get 'api/apply/:character_id/advance' => 'applications#advance_application_status'

  # approval Kinds
  get 'api/approval-kinds' => 'approval_kind#list'

  # approvals controller
  post 'api/approvals' => 'approvals#create_approval'
  post 'api/approvals/approver' => 'approvals#add_approver'
  delete 'api/approvals/approver/:approver_id' => 'approvals#not_needed_approver'
  get 'api/approval/types' => 'approvals#approval_types'
  get 'api/approvals/pending/' => 'approvals#pending_approval_count'
  get 'api/approvals/:approval_id/:approval_type' => 'approvals#approval_request'
  post 'api/approvals/override/' => 'approvals#approval_override'
  post 'api/approvals/override/:approval_id' => 'approvals#approval_override_specific'

  # awards
  get 'api/award' => 'awards#list'
  post 'api/award' => 'awards#create'
  patch 'api/award/:award_id' => 'awards#update'
  delete 'api/award/:award_id' => 'awards#archive'

  # badges
  get 'api/badge' => 'badge#list'
  post 'api/badge' => 'badge#create'
  patch 'api/badge/:badge_id' => 'badge#update'
  put 'api/badge/:badge_id' => 'badge#update'
  delete 'api/badge/:badge_id' => 'badge#archive'

  # Bots
  get 'api/bot' => 'bot#list'
  post 'api/bot' => 'bot#create'
  delete 'api/bot/:bot_id' => 'bot#destroy'
  get 'api/bot/check' => 'bot#bot_check'

  # chat
  get 'api/chat' => 'chat#list'
  post 'api/chat' => 'chat#create'
  put 'api/chat' => 'chat#update'
  delete 'api/chat/:chat_id' => 'chat#delete'

  # commodities
  get 'api/tools/commodities/' => 'commodities#list'
  post 'api/tools/commodities/' => 'commodities#create'
  patch 'api/tools/commodities/:ti_id' => 'commodities#update'
  delete 'api/tools/commodities/:ti_id' => 'commodities#destroy'
  post 'api/tools/commodities/:ti_id/value' => 'commodities#add_value'
  patch 'api/tools/commodities/:ti_id/value' => 'commodities#update_value'
  get 'api/tools/commodities/:ti_id/value/:trade_value_id' => 'commodities#destroy_value'

  # divisions
  get 'api/division' => 'divisions#list'

  # donations
  get 'api/donation' => 'donation#list'
  get 'api/donation/mine' => 'donation#my_donations'
  get 'api/donation/:donation_item_id' => 'donation#fetch'
  post 'api/donation/' => 'donation#create'
  patch 'api/donation/' => 'donation#update'
  put 'api/donation/' => 'donation#update'
  delete 'api/donation/:donation_item_id' => 'donation#archive'
  post 'api/donation/make' => 'donation#donate'

  # events
  get 'api/events' => 'events#list'
  get 'api/events/next' => 'events#list_next'
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
  post 'api/events/attend/auto' => 'events#set_auto_attendance'
  get 'api/events/types' => 'events#get_types'
  get 'api/events/attendence-types' => 'events#get_attendence_types'
  get 'api/events/:event_id/certify' => 'events#certify_event_attendence'
  post 'api/events/:event_id/certify' => 'events#certify_event_attendence_post'
  get 'api/events/:event_id' => 'events#show'
  delete 'api/events/:event_id/' => 'events#archive_event'

  # factions
  scope 'api', as: 'api' do
    get 'factions' => 'faction_affiliation#list'
    post 'factions' => 'faction_affiliation#create'
    put 'factions' => 'faction_affiliation#update'
    delete 'factions/:id' => 'faction_affiliation#archive'
  end

  # field descriptors
  post 'api/fields/descriptor' => 'field_descriptors#create'
  put 'api/fields/descriptor' => 'field_descriptors#update'
  delete 'api/fields/descriptor/:id' => 'field_descriptors#archive'

  # field
  get 'api/fields' => 'fields#list'
  get 'api/fields/classes' => 'fields#field_classes'
  get 'api/fields/:id' => 'fields#show'
  post 'api/fields/multi' => 'fields#show_multi'
  get 'api/fields/:id/details' => 'fields#show_details'
  post 'api/fields/' => 'fields#create'
  put 'api/fields/' => 'fields#update'
  delete 'api/fields/:id' => 'fields#archive'

  patch 'api/field-value' => 'field_value#patch'
  delete 'api/field-value/:id' => 'field_value#delete'

  # flight Logs
  get 'api/flight-logs' => 'flight_logs#list'
  get 'api/flight-logs/ships' => 'flight_logs#list_ships'
  get 'api/flight-logs/:flight_log_id' => 'flight_logs#show'
  post 'api/flight-logs' => 'flight_logs#create'
  put 'api/flight-logs' => 'flight_logs#update'
  patch 'api/flight-logs' => 'flight_logs#update'
  delete 'api/flight-logs/:flight_log_id' => 'flight_logs#delete'

  # images
  get 'api/images' => 'image_uploads#index'
  post 'api/images' => 'image_uploads#create'
  delete 'api/images' => 'image_uploads#destroy'

  # incidents (new offender reports)
  get 'api/incident' => 'incident_reports#index'
  get 'api/incident/my' => 'incident_reports#index_mine'
  get 'api/incident/assigned' => 'incident_reports#index_assigned'
  post 'api/incident/comment' => 'incident_reports#add_comment'
  delete 'api/incident/comment/:id' => 'incident_reports#delete_comment'
  get 'api/incident/:id' => 'incident_reports#show'
  put 'api/incident/:id' => 'incident_reports#update'
  get 'api/incident/:id/approve' => 'incident_reports#approve_report'
  get 'api/incident/:id/decline' => 'incident_reports#decline_report'
  post 'api/incident' => 'incident_reports#create'
  post 'api/incident/:id/comment' => 'incident_reports#add_comment'
  delete 'api/incident/:id/comment/:comment_id' => 'incident_reports#delete_comment'

  # intel
  get 'api/intel' => 'intelligence_cases#index'
  get 'api/intel/officers' => 'intelligence_cases#list_assignable_officers'
  post 'api/intel/comment' => 'intelligence_cases#add_comment'
  delete 'api/intel/comment/:id' => 'intelligence_cases#delete_comment'
  get 'api/intel/:id' => 'intelligence_cases#show'
  put 'api/intel/:id' => 'intelligence_cases#update'
  post 'api/intel' => 'intelligence_cases#create'
  post 'api/intel/:id/comment' => 'intelligence_cases#add_comment'
  delete 'api/intel/:id/comment/:comment_id' => 'intelligence_cases#delete_comment'

  # job Board
  get 'api/job-board/' => 'job_board#list'
  get 'api/job-board/types' => 'job_board#list_types'
  post 'api/job-board/' => 'job_board#create'
  patch 'api/job-board/' => 'job_board#update'
  post 'api/job-board/accept' => 'job_board#accept_mission'
  post 'api/job-board/abandon' => 'job_board#abandon_mission'
  post 'api/job-board/complete' => 'job_board#complete_mission'
  get 'api/job-board/:mission_id/' => 'job_board#show'
  delete 'api/job-board/:mission_id/' => 'job_board#delete'

  # bendro safe
  post 'api/safe/search' => 'bendro_safe#profile_search'

  # 'jobs' (as in employment ops)
  get 'api/job' => 'jobs#list'
  get 'api/job/hiring' => 'jobs#list_hiring'
  get 'api/job/types' => 'jobs#job_types'
  post 'api/job/' => 'jobs#create'
  patch 'api/job/' => 'jobs#update'
  put 'api/job/' => 'jobs#update'

  # laws
  get 'api/law/organized' => 'law#fetch_laws_organized'
  get 'api/law' => 'law#fetch_laws'
  post 'api/law' => 'law#create_law'
  put 'api/law' => 'law#update_law'
  delete 'api/law/:law_id' => 'law#archive_law'
  get 'api/law/jurisdiction' => 'law#fetch_jurisdictions'
  get 'api/law/jurisdiction/:jurisdiction_id' => 'law#fetch_jurisdiction'
  post 'api/law/jurisdiction' => 'law#create_jurisdiction'
  put 'api/law/jurisdiction' => 'law#update_jurisdiction'
  delete 'api/law/jurisdiction/:jurisdiction_id' => 'law#archive_jurisdiction'
  get 'api/law/category' => 'law#fetch_categories'
  get 'api/law/category/:jurisdiction_id' => 'law#fetch_categories'
  post 'api/law/category' => 'law#create_category'
  put 'api/law/category' => 'law#update_category'
  delete 'api/law/category/:category_id' => 'law#archive_category'

  # liability
  get 'api/liability' => 'liability#list'

  # menu items
  get 'api/menu' => 'menu_items#list'
  post 'api/menu' => 'menu_items#create'
  patch 'api/menu' => 'menu_items#update'
  delete 'api/menu/:menu_item_id' => 'menu_items#delete'

  # news
  get 'api/news' => 'rp_news_stories#index'
  get 'api/news/public' => 'rp_news_stories#index_public'
  get 'api/news/:news_id' => 'rp_news_stories#show'
  post 'api/news/' => 'rp_news_stories#create'
  put 'api/news/' => 'rp_news_stories#update'
  delete 'api/news/:news_id' => 'rp_news_stories#destroy'

  # offender reports
  get 'api/offender-report' => 'offender_reports#list'
  get 'api/offender-report/types' => 'offender_reports#list_types'
  get 'api/offender-report/mine' => 'offender_reports#list_mine'
  get 'api/offender-report/admin' => 'offender_reports#list_admin'
  post 'api/offender-report/submit' => 'offender_reports#submit'
  get 'api/offender-report/infractions' => 'offender_reports#list_infractions'
  get 'api/offender-report/force-levels' => 'offender_reports#list_force_levels'
  get 'api/offender-reports/verify/:rsi_handle' => 'offender_reports#verify_rsi_handle'
  get 'api/offender-reports/search/:rsi_handle' => 'offender_reports#profile_search'
  get 'api/offender-report/offender/:offender_id' => 'offender_reports#fetch_offender'
  get 'api/offender-report/:report_id' => 'offender_reports#fetch'
  post 'api/offender-report' => 'offender_reports#create'
  patch 'api/offender-report' => 'offender_reports#update'

  # page entries
  get 'api/pages' => 'page_entries#list'
  post 'api/pages' => 'page_entries#create_page'
  patch 'api/pages' => 'page_entries#update_page'
  put 'api/pages' => 'page_entries#update_page'
  delete 'api/pages/:page_id' => 'page_entries#delete_page'
  get 'api/pages/search/:uuid_segment' => 'page_entries#id_search'
  post 'api/pages/publish' => 'page_entries#publish'
  post 'api/pages/unpublish' => 'page_entries#unpublish'
  post 'api/pages/add-role' => 'page_entries#add_role'
  post 'api/pages/remove-role' => 'page_entries#remove_role'
  get 'api/pages/category' => 'page_entries#fetch_categories'
  post 'api/pages/category' => 'page_entries#update_category'
  patch 'api/pages/category' => 'page_entries#update_category'
  get 'api/pages/category/:page_category_id' => 'page_entries#delete_category'
  # page image routes
  post 'api/pages/:page_id/images' => 'page_entries#create_image'
  delete 'api/pages/:page_id/images' => 'page_entries#destroy_image'

  # at the bottom
  get 'api/pages/:page_id' => 'page_entries#show'

  # profiles
  get 'api/profile' => 'profiles#list'
  get 'api/profile/member' => 'profiles#list_members'
  get 'api/profile/by-group' => 'profiles#list_groups'
  get 'api/profile/not-grouped' => 'profiles#list_not_grouped'
  get 'api/profile/by-division' => 'profiles#list_by_divsion'
  patch 'api/profile/avatar' => 'profiles#update_avatar'
  post 'api/profile/ship' => 'profiles#add_ship'
  patch 'api/profile/ship' => 'profiles#update_ship'
  patch 'api/profile/handle' => 'profiles#update_handle'
  put 'api/profile/handle' => 'profiles#update_handle'
  delete 'api/profile/ship/:owned_ship_id' => 'profiles#remove_ship'
  post 'api/profile/comment' => 'profiles#add_application_comment'
  # keep these at the bottom of the profile list
  get 'api/profile/:profile_id' => 'profiles#show'
  patch 'api/profile' => 'profiles#update'


  # reports
  scope 'api', as: 'api' do
    get 'reports/fields' => 'report_fields#index'
    post 'reports/fields' => 'report_fields#create'
    put 'reports/fields' => 'report_fields#update'
    delete 'reports/fields/:id' => 'report_fields#destroy'
    # resources :report_fields, path: 'reports/fields', only: [:index, :create, :update, :destroy]
    # resources :report_templates, path: 'reports/templates', only: [:index, :show, :create, :update, :destroy]
    get 'reports/templates/handlers' => 'report_handler#index'
    get 'reports/templates' => 'report_templates#index'
    get 'reports/templates/:id' => 'report_templates#show'
    post 'reports/templates' => 'report_templates#create'
    put 'reports/templates' => 'report_templates#update'
    delete 'reports/templates/:id' => 'report_templates#destroy'
    # resources :report_field_values, path: 'reports/values', only: [:update]
    put 'reports/values' => 'report_field_values#update'
    # resources :reports, path: 'reports', only: [:index, :create, :update, :destroy]
    get 'reports' => 'reports#index'
    get 'reports/routes' => 'reports#fetch_routes'
    get 'reports/handlers' => 'reports#fetch_handlers'
    post 'reports' => 'reports#create'
    put 'reports' => 'reports#update'
    get 'reports/:id' => 'reports#show'
    delete 'reports/:id' => 'reports#destroy'
  end

  # roles
  get 'api/role' => 'roles#list'
  get 'api/role/simple' => 'roles#list'
  get 'api/role/admin' => 'roles#admin_fetch_roles'
  post 'api/role' => 'roles#create_role'
  patch 'api/role' => 'roles#update_role'
  put 'api/role' => 'roles#update_role'
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

  # Site Logs
  get 'api/site-logs' => 'site_log#list'

  # subscriptions
  post 'api/subscription' => 'subscription#create'
  delete 'api/subscription' => 'subscription#delete'
  post 'api/subscription/stripe_callback' => 'subscription#callback_for_stripe'

  # use of the above system map routes is deprecated and they will be removed
  get 'api/system-map/object' => 'star_object#list'
  get 'api/system-map/rules' => 'star_object#list_rules'
  get 'api/system-map/object/search/:uuid_segment' => 'star_object#id_search'
  get 'api/system-map/object/:id' => 'star_object#show'
  post 'api/system-map/object' => 'star_object#create'
  put 'api/system-map/object' => 'star_object#update'
  delete 'api/system-map/object/:id' => 'star_object#archive'
  # system map images
  post 'api/system-map/image' => 'system_map_images#create'
  put 'api/system-map/image' => 'system_map_images#update'
  delete 'api/system-map/image/:image_id' => 'system_map_images#archive'

  # training
  get 'api/training' => 'training#list_courses'
  get 'api/training/types' => 'training#fetch_types'
  get 'api/training/badges' => 'training#fetch_badges'
  get 'api/training/instructors' => 'training#fetch_instructors'
  get 'api/training/:course_id' => 'training#fetch_course'
  post 'api/training' => 'training#create_course'
  patch 'api/training' => 'training#update_course'
  put 'api/training' => 'training#update_course'
  post 'api/training/item' => 'training#create_training_item'
  patch 'api/training/item' => 'training#update_training_item'
  put 'api/training/item' => 'training#update_training_item'
  post 'api/training/item/complete' => 'training#complete_training_item'
  delete 'api/training/item/:training_item_id' => 'training#archive_training_item'
  delete 'api/training/:course_id' => 'training#archive_course'


  # users
  get 'api/user' => 'users#list'
  get 'api/user/me' => 'users#me'
  get 'api/user/approval/:approval_approver_id' => 'users#approval'
  get 'api/user/approvals' => 'users#approvals'
  get 'api/user/approvals/:count' => 'users#approvals'
  get 'api/user/approvals/:count/:skip' => 'users#approvals'
  get 'api/user/approvals-count' => 'users#approvals_count'
  get 'api/user/approvals-count-total' => 'users#approvals_count_total'
  get 'api/user/oauth-tokens' => 'users#oauth_tokens'
  get 'api/user/auth-tokens' => 'users#auth_tokens'
  post 'api/user/push-token' => 'users#add_push_token'
  get 'api/user/push' => 'users#push_self'
  get 'api/user/push/:user_id' => 'users#push_self'
  post 'api/user/discord-identity' => 'users#discord_identity'
  put 'api/user/discord-identity/:discord_identity_id' => 'users#discord_identity_joined'
  get 'api/user/event-test' => 'users#event_self'
  post 'api/user/end-membership' => 'users#end_membership'

  # oauth
  post 'api/oauth-client-check' => 'oauth#client_check'
  post 'api/oauth-token' => 'oauth#oauth_post'
  delete 'api/oauth-token/:token' => 'oauth#remove_token'

  #############################
  # All other routes go above here
  # This two routes should always be at the bottom of the list of routes
  #############################
  #############################
  #############################
	match '*any' => 'application#options', :via => [:options]
	match "*path", to: "pages#not_found", via: :all
end
