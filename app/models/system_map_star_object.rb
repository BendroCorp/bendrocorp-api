class SystemMapStarObjectValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base] << 'This object cannot be mapped to the specified object' unless record.can_map?
  end
end

class SystemMapStarObject < ApplicationRecord
  has_paper_trail # auditing changes

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

  has_many :system_map_images, -> { order 'system_map_images.created_at desc' }, class_name: 'SystemMapImage', foreign_key: 'of_star_object_id'

  belongs_to :parent, class_name: 'SystemMapStarObject', optional: true, foreign_key: :parent_id
  has_many :children, class_name: 'SystemMapStarObject', dependent: :destroy, foreign_key: :parent_id

  # experimental, undo if this breaks
  belongs_to :master, class_name: 'MasterId', optional: true, foreign_key: :id

  def primary_image_url
    self.primary_image.image_url_thumbnail if self.primary_image
  end

  def primary_image_url_full
    self.primary_image.image_url if self.primary_image
  end

  # def master
  #   MasterId.find_by id: id
  # end

  def title_with_kind
    "#{title} (#{kind})"
  end

  def kind
    object_type.title if object_type
  end

  def fields
    # TODO: Figure out how to get the descriptors
    master.type.fields # .joins(:field_descriptors)
  end

  def field_values
    master.field_values
  end

  def can_map?
    if !parent.nil?
      SystemMapMappingRule.where(child_id: object_type_id, parent_id: parent.object_type_id).count > 1
    end
    true
  end

  private
    def set_id
      # 209a90cd-5546-4353-83f6-36d7b025a96f - StarObject - this doesn't work for field binding
      master_id = MasterId.create(type_id: self.object_type_id, update_role_id: 22)
      self.id = master_id.id
    end
end
