class ReportTemplateField < ApplicationRecord
  # audited
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  before_save { self.field_id = nil unless self.field_presentation_type_id == 5 }
  
  validate :validate_field_id_if_pres_five
  
  validates :template_id, presence: true
  belongs_to :template, class_name: 'ReportTemplate', foreign_key: 'template_id', optional: true # required

  belongs_to :field, optional: true

  # validators
  validates :name, presence: true
  validates :field_presentation_type_id, presence: true
  validates :ordinal, presence: true

  def validate_field_id_if_pres_five
    if self.template && self.template.draft = false
      if self.template.field_presentation_type_id == 5 && self.field_id
        # return true
      else
        errors.add(:field_id, 'needs to be present if field presentation type is selected')
      end
    else
      # return true
    end
  end
end