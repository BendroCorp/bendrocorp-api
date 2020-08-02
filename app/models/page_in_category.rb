class PageInCategory < ApplicationRecord
  belongs_to :page, class_name: 'Page', foreign_key: 'page_id', optional: true
  belongs_to :category, class_name: 'FieldDescriptor', foreign_key: 'category_id', optional: true

  validates :page_id, presence: true
  validates :category_id, presence: true
end
