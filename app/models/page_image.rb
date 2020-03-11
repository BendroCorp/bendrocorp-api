class PageImage < ApplicationRecord
  validates :page_id, presence: true
  belongs_to :page, optional: true
  validates :image_upload_id, presence: true
  belongs_to :image_upload, dependent: :destroy, optional: true
end
