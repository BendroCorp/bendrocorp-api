class SystemMapSystemGravityWellLuminosityClass < ApplicationRecord
    has_many :gravity_wells, :class_name => 'SystemMapSystemGravityWell', :foreign_key => 'luminosity_class_id'
end
