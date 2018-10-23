class UserInformation < ApplicationRecord
  belongs_to :user
  belongs_to :country, :class_name => 'UserCountry', :foreign_key => 'country_id'

  def completed
    if self.first_name != nil && self.last_name != nil && self.street_address != nil && self.city != nil && self.state != nil && self.zip != nil && self.country_id != nil
      true
    else
      false
    end
  end
end
