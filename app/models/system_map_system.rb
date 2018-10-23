class SystemMapSystem < ApplicationRecord

  has_many :gravity_wells, :class_name => 'SystemMapSystemGravityWell', :foreign_key => 'system_id'

  has_many :planets, :class_name => 'SystemMapSystemPlanetaryBody', :foreign_key => 'orbits_system_id'

  has_many :system_objects, :class_name => 'SystemMapSystemObject', :foreign_key => 'orbits_system_id'

  belongs_to :discovered_by, :class_name => 'User', :foreign_key => 'discovered_by_id'

  has_many :system_map_images, :class_name => 'SystemMapImage', :foreign_key => 'of_system_id'

  def jump_points
    syss= SystemMapSystemConnection.where("system_one_id = ? OR system_two_id = ? ", self.id, self.id)
    ret = []

    syss.each do |sys|
      if sys.system_one_id == self.id && sys.system_two_id != self.id
        ret << { title: sys.system_one.title, id: sys.system_one.id }
      else
        ret << { title: sys.system_two.title, id: sys.system_two.id }
      end
    end
    ret
  end

  accepts_nested_attributes_for :planets
  accepts_nested_attributes_for :gravity_wells
  accepts_nested_attributes_for :system_objects
end
