class Field < ApplicationRecord
  before_create do
    self.id = SecureRandom.uuid if id.nil? && ENV['RAILS_ENV'] != 'production'
  end

  # validates :created_by_id, presence: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id', optional: true
  belongs_to :field_descriptor_class, optional: true
  belongs_to :field_descriptor_field, class_name: 'Field', foreign_key: :field_descriptor_field_id, optional: true
  has_many :field_descriptors, -> { where(archived: false).where("ordinal >": 0).order(:ordinal) }, class_name: 'FieldDescriptor', foreign_key: 'field_id'

  belongs_to :presentation_type, class_name: 'FieldDescriptor', foreign_key: :presentation_type_id, optional: true

  def descriptors
    raise 'from_class and from_field' if from_class && from_field

    # if we are not getting descriptors from a class or field
    return field_descriptors.order('ordinal') if !from_class && !from_field

    # if we are getting descriptors from a class
    return field_descriptor_class.field_data if from_class

    # get the descriptors from another field...
    # this is useful if you want another name displayed
    return field_descriptor_field.descriptors if from_field
  end

  def from_class
    true unless field_descriptor_class.nil?
  end

  def from_field
    true unless field_descriptor_field.nil?
  end
end
