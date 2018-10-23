class Ship < ActiveRecord::Base
  has_many :owned_ships
  has_many :characters, through: :owned_ships
end
