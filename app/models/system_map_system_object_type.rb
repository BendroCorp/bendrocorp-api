class SystemMapSystemObjectType < ApplicationRecord
  has_many :system_objects, :class_name => 'SystemMapSystemObject', :foreign_key => 'object_type_id'
end
