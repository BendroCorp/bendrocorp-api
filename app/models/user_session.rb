class UserSession < ApplicationRecord
    before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

    belongs_to :user
    geocoded_by :ip_address,
    :latitude => :lat, :longitude => :lon
    after_validation :geocode
end
