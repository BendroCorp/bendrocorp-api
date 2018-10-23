class SystemMapSystemGravityWellType < ApplicationRecord
  has_many :gravity_wells, :class_name => 'SystemMapSystemGravityWell', :foreign_key => 'gravity_well_type_id'
end
