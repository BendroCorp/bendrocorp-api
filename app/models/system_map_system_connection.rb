class SystemMapSystemConnection < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

  belongs_to :system_map_system_connection_status
  belongs_to :system_map_system_connection_size
  belongs_to :system_one, :class_name => 'SystemMapSystem', :foreign_key => 'system_one_id'
  belongs_to :system_two, :class_name => 'SystemMapSystem', :foreign_key => 'system_two_id'
end
