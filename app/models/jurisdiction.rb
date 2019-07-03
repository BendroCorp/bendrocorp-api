class Jurisdiction < ApplicationRecord
    has_many :laws, -> { where archived: false }, class_name: 'JurisdictionLaw', foreign_key: 'jurisdiction_id'
    has_many :categories, -> { where archived: false }, class_name: 'JurisdictionLawCategory', foreign_key: 'jurisdiction_id'
    belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'

    validates :title, presence: true, length: { minimum:3, maximum: 200 }
end
