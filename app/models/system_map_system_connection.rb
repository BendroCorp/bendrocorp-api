class SystemMapSystemConnection < ApplicationRecord
  belongs_to :system_map_system_connection_status
  belongs_to :system_map_system_connection_size
  belongs_to :system_one, :class_name => 'SystemMapSystem', :foreign_key => 'system_one_id'
  belongs_to :system_two, :class_name => 'SystemMapSystem', :foreign_key => 'system_two_id'
end
