class AwardsAwarded < ActiveRecord::Base
  belongs_to :character
  belongs_to :award
end
