class Division < ActiveRecord::Base
  has_many :jobs
  has_many :characters, :through => :jobs

  has_many :division_groups

  def division_members
    division_member_arr = []
    self.characters.each do |character|
      if character.current_division == self
        c = { id: character.id, avatar_url: character.avatar_url, full_name: character.full_name, first_name: character.first_name, last_name: character.last_name, current_job: character.current_job, current_job_level: character.current_job_level, division: character.current_division, rsi_handle: character.rsi_handle }
        division_member_arr << c
      end
    end

    #sort them
    division_member_arr.sort_by! { |member| member[:current_job_level] }

    # puts division_member_arr.inspect
    division_member_arr.uniq!
    division_member_arr
  end
end
