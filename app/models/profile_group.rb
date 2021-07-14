class ProfileGroup < ApplicationRecord
  belongs_to :division # temp to carry us over from the old system until we do heiarchies
  belongs_to :parent, optional: true
end
