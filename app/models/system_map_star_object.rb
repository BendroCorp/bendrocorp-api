class SystemMapStarObjectValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base] << 'This object cannot be mapped to the specified object' unless record.can_map?
  end
end

class SystemMapStarObject < ApplicationRecord
  validates_with SystemMapStarObjectValidator
  before_create :set_id

  validates :title, presence: true
  validates :description, presence: true
  validates :object_type_id, presence: true

  belongs_to :object_type, class_name: 'FieldDescriptor', foreign_key: 'object_type_id', optional: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id', optional: true
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id', optional: true

  belongs_to :primary_image, class_name: 'SystemMapImage', foreign_key: 'primary_image_id', optional: true
  accepts_nested_attributes_for :primary_image

  has_many :system_map_images, class_name: 'SystemMapImage', foreign_key: 'of_star_object_id'

  belongs_to :parent, class_name: 'SystemMapStarObject', optional: true, foreign_key: :parent_id
  has_many :children, class_name: 'SystemMapStarObject', dependent: :destroy, foreign_key: :parent_id

  def primary_image_url
    self.primary_image.image_url_thumbnail if self.primary_image
  end

  def primary_image_url_full
    self.primary_image.image_url if self.primary_image
  end

  def master
    MasterId.find_by id: id
  end

  def kind
    object_type.title if object_type
  end

  def field_values
    # TODO: May need to do more here for ordering and what not
    # TODO/TODO: There is a lot more to do here to include field data
    # master.field_values
  end

  def can_map?
    if !parent.nil?
      SystemMapMappingRule.where(child_id: object_type_id, parent_id: parent.object_type_id).count > 1
    end
    true
  end

  private
    def set_id
      master_id = MasterId.create(type_id: '209a90cd-5546-4353-83f6-36d7b025a96f')
      self.id = master_id.id
    end
end
