class JurisdictionLaw < ApplicationRecord
    belongs_to :jurisdiction, class_name: 'Jurisdiction', foreign_key: 'jurisdiction_id', optional: true
    belongs_to :law_category, class_name: 'JurisdictionLawCategory', foreign_key: 'law_category_id', optional: true
    enum law_class: { felony: 1, misdemeanor: 2 }
    validates :created_by_id, presence: true
    belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id', optional: true

    validates :title, presence: true, length: { minimum:3, maximum: 200 }
    validates :law_class, presence: true
    validates :law_category_id, presence: true
    validates :jurisdiction_id, presence: true
end
