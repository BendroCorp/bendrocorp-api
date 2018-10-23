class DivisionGroup < ApplicationRecord
  has_many :division_in_groups
  has_many :characters, through: :division_in_groups
end
