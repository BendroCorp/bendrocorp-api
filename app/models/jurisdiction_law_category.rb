class JurisdictionLawCategory < ApplicationRecord
    has_many :laws, -> { where archived: false }, class_name: 'JurisdictionLaw', foreign_key: 'law_category_id'
    belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id', optional: true
    belongs_to :jurisdiction, optional: true

    validates :title, presence: true, length: { minimum: 3, maximum: 200 }
    validates :jurisdiction_id, presence: true
end
