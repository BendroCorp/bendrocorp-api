class Page < ActiveRecord::Base
  has_many :page_entry_edits
  has_many :page_entry_roles
  has_many :roles, through: :page_entry_roles

  validates :title, presence: true

  validates :creator_id, presence: true
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  has_many :page_in_categories, class_name: 'PageInCategory', foreign_key: 'page_id'
  has_many :categories, through: :page_in_categories, class_name: 'FieldDescriptor', foreign_key: 'category_id'
  belongs_to :classification_level, optional: true

  has_many :page_images, dependent: :destroy
  has_many :image_uploads, through: :page_images

  accepts_nested_attributes_for :page_entry_edits
  accepts_nested_attributes_for :page_entry_roles
  accepts_nested_attributes_for :page_in_categories
end
