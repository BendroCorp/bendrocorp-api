class Ship < ActiveRecord::Base
  has_many :owned_ships
  has_many :characters, through: :owned_ships

  def full_title
    unless manufacturer.nil?
      "#{title} (#{manufacturer})"
    else
      title
    end
  end
end
