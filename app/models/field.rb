class Field < ApplicationRecord
  before_create do
    self.id = SecureRandom.uuid if id.nil? && ENV['RAILS_ENV'] != 'production'
  end

  # validates :created_by_id, presence: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id', optional: true
  belongs_to :field_descriptor_class, optional: true
  has_many :field_descriptors, -> { where archived: false }, class_name: 'FieldDescriptor', foreign_key: 'field_id'

  def descriptors
    if from_class
      return self.field_descriptor_class.field_data
    else
      return self.field_descriptors.order('ordinal')
    end
  end

  def from_class
    true unless field_descriptor_class.nil?
  end
end
