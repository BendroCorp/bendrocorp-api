class AddSystemMapItemRequest < ApplicationRecord

  validates :user_id, presence: true
  belongs_to :user, optional: true #required field/fk
  belongs_to :approval #required field/fk
  belongs_to :system_map_object_kind

  # t.belongs_to :system_map_object_kind, index: false
  # t.integer :kind_pk

  def approval_completion #what happens when the approval is approved
    daObject = find_system_map_parent
    daObject.approved = true
    daObject.save

    # TODO: Spawn off catalogue missions with some variation based on type
    # :title, :description, :completion_criteria_id, :starts_when, :expires_when, :max_acceptors, :op_value, :system_id, :planet_id, :moon_id, :system_object_id, :location_id
    @job = JobBoardMission.new()
    @job.created_by_id = 0
    @job.updated_by_id = 0
    @job.mission_status_id = 1 # open
    @job.completion_criteria_id = 3 #catalogue request
    @job.starts_when = Time.now
    @job.op_value = 5 # TODO: eventually this needs to be calculated - based on the distance from Stanton - for covering fuel and compensation
    @job.max_acceptors = 1

    #  flavor text for titles and descriptions based on what the object is
    # TODO: Implement some randomness in the titles
    if self.system_map_object_kind_id == 1 # system
      @job.title = "New system discovered!"
      @job.description = "A new system has been discovered/added to system map called #{object_title} as the time posting. BendroCorp requires a general survey of the system to be made. General survery are meant to be a high level survey to discover more objects. To complete the mission created a flight log for this system which includes images taken from the system."
    elsif self.system_map_object_kind_id == 2 # gw
      @job.title = "New gravity well needs documentation!"
      @job.description = "A new gravity well called #{object_title} has been discovered and needs documentation and imaging!"
    elsif self.system_map_object_kind_id == 3 # planet
      @job.title = "New world found!"
      @job.description = "A new world that our discover has called #{object_title} has been found and needs a basic catelogue to be preformed!"
    elsif self.system_map_object_kind_id == 4 # moon
      @job.title = "New moon discovered!"
      @job.description = "Its like moons just keep appearing out of no where and it needs a basic catelogue to be preformed. Its name is #{object_title}."
    elsif self.system_map_object_kind_id == 5 # so
      @job.title = "New system object found!"
      @job.description = "A new non-planetary orbital object has been located and it needs to be explored it is called #{object_title}."
    elsif self.system_map_object_kind_id == 6 # settlement
      @job.title = "New settlement found!"
      @job.description = "A new settlement has been located and it is called #{object_title} and has been located on "
      parent = find_system_map_parent
      if parent.on_planet != nil && parent.on_moon == nil
        @job.description = "#{@job.description} #{parent.on_planet.title} "
      elsif parent.on_planet == nil && parent.on_moon != nil
        @job.description = "#{@job.description} #{parent.on_moon.title} "
      end
      @job.description = "#{@job.description}. It needs all of its locations surveyed."
    elsif self.system_map_object_kind_id == 7 # location
      @job.title = "New location found!"
      @job.description = "A new location called #{object_title} has been found on/in "
      parent = find_system_map_parent
      # planet
      if parent.on_planet != nil && parent.on_moon == nil && parent.on_system_object == nil && parent.on_settlement == nil
        @job.description = "#{@job.description} #{parent.on_planet.title} "

      #moon
      elsif parent.on_planet == nil && parent.on_moon != nil && parent.on_system_object == nil && parent.on_settlement == nil
        @job.description = "#{@job.description} #{parent.on_moon.title} "

      # system object
      elsif parent.on_planet == nil && parent.on_moon == nil && parent.on_system_object != nil && parent.on_settlement == nil
          @job.description = "#{@job.description} #{parent.on_system_object.title} "

        #settlement
      elsif parent.on_planet == nil && parent.on_moon == nil && parent.on_system_object == nil && parent.on_settlement != nil
          @job.description = "#{@job.description} #{parent.on_settlement.title} "
      end
      @job.description = "#{@job.description}."
    elsif self.system_map_object_kind_id == 8 # fauna
      @job.title = "New fauna located!"
      @job.description = "A new creature tenatively called #{object_title} has been located on "
      parent = find_system_map_parent
      # planet
      if parent.on_planet != nil && parent.on_moon == nil && parent.on_system_object == nil
        @job.description = "#{@job.description} #{parent.on_planet.title} "

      #moon
      elsif parent.on_planet == nil && parent.on_moon != nil && parent.on_system_object == nil
        @job.description = "#{@job.description} #{parent.on_moon.title} "

      # system object
      elsif parent.on_planet == nil && parent.on_moon == nil && parent.on_system_object != nil
          @job.description = "#{@job.description} #{parent.on_system_object.title} "
      end
      @job.description = "#{@job.description}. To complete the job create a single flight log with images and data for this creature per the standard catalogue criteria."
    elsif self.system_map_object_kind_id == 9 # flora
      @job.title = "New planet life found!"
      @job.description = "New plant life tenatively named #{object_title} has been located on "
      parent = find_system_map_parent
      # planet
      if parent.on_planet != nil && parent.on_moon == nil && parent.on_system_object == nil
        @job.description = "#{@job.description} #{parent.on_planet.title} "

      #moon
      elsif parent.on_planet == nil && parent.on_moon != nil && parent.on_system_object == nil
        @job.description = "#{@job.description} #{parent.on_moon.title} "

      # system object
      elsif parent.on_planet == nil && parent.on_moon == nil && parent.on_system_object != nil
          @job.description = "#{@job.description} #{parent.on_system_object.title} "
      end
      @job.description = "#{@job.description}. To complete the job create a single flight log with images and data for this plant life per the standard catalogue criteria."
    elsif self.system_map_object_kind_id == 10 # jump point
      #system_one, system_two
      parent = find_system_map_parent
      @job.title = "New jump point located!"
      @job.description = "A new jump point has been located which goes between #{parent.system_one_title} and #{parent.system_two.title}. Full verification and imagery needs to be taken for the jump point. Along with what is on the other side!"
    end

    # which object - :system_id, :planet_id, :moon_id, :system_object_id, :location_id, :flora_id, :fauna_id
    #save back the object
    @job.save

  end

  def approval_denied #what happens when the approval is denied
    # if a request is denied we just delete the object
    daObject = find_system_map_parent
    if self.system_map_object_kind_id == 1
      daObject.jump_points.each do |jp|
        jp.destroy
      end
    end
    daObject.destroy
  end

  def find_system_map_parent
    if self.system_map_object_kind_id == 1 # system
      SystemMapSystem.find_by_id(self.kind_pk)
    elsif self.system_map_object_kind_id == 2 # gw
      SystemMapSystemGravityWell.find_by_id(self.kind_pk)
    elsif self.system_map_object_kind_id == 3 # planet
      SystemMapSystemPlanetaryBody.find_by_id(self.kind_pk)
    elsif self.system_map_object_kind_id == 4 # moon
      SystemMapSystemPlanetaryBodyMoon.find_by_id(self.kind_pk)
    elsif self.system_map_object_kind_id == 5 # so
      SystemMapSystemObject.find_by_id(self.kind_pk)
    elsif self.system_map_object_kind_id == 6 # settlement
      SystemMapSystemSettlement.find_by_id(self.kind_pk)
    elsif self.system_map_object_kind_id == 7 # location
      SystemMapSystemPlanetaryBodyLocation.find_by_id(self.kind_pk)
    elsif self.system_map_object_kind_id == 8 # fauna
      SystemMapFauna.find_by_id(self.kind_pk)
    elsif self.system_map_object_kind_id == 9 # flora
      SystemMapFlora.find_by_id(self.kind_pk)
    elsif self.system_map_object_kind_id == 10 # jump point
      SystemMapSystemConnection.find_by_id(self.kind_pk)
    end
  end

  def object_kind
    if self.system_map_object_kind_id == 1 # system
      "System"
    elsif self.system_map_object_kind_id == 2 # gw
      "Gravity Well"
    elsif self.system_map_object_kind_id == 3 # planet
      "Planet"
    elsif self.system_map_object_kind_id == 4 # moon
      "Moon"
    elsif self.system_map_object_kind_id == 5 # so
      "System Object"
    elsif self.system_map_object_kind_id == 6 # settlement
      "Settlement"
    elsif self.system_map_object_kind_id == 7 # location
      "Location"
    elsif self.system_map_object_kind_id == 8 # fauna
      "Fauna"
    elsif self.system_map_object_kind_id == 9 # flora
      "Flora"
    elsif self.system_map_object_kind_id == 10 # jump point
      "Jump Point"
    end
  end

  def object_title
    if find_system_map_parent
      find_system_map_parent.title
    else
      "Object Removed"
    end
  end
end
