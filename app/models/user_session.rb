class UserSession < ApplicationRecord
    before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

    belongs_to :user
    # geocoded_by :ip_address,
    # :latitude => :latitude, :longitude => :longitude, :address => :location
    geocoded_by :ip_address do |obj,results|
        if (geo = results.first)
            obj.latitude = geo.latitude
            obj.longitude = geo.longitude
            obj.location = geo.address
            obj.country_code = geo.country_code
        end
    end
after_validation :geocode
end
