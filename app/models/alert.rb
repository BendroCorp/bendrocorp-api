class Alert < ApplicationRecord
  has_paper_trail # auditing changes

  validates :title, presence: true
  validates :description, presence: true

  belongs_to :star_object, class_name: 'SystemMapStarObject', foreign_key: :star_object_id, optional: true

  # these items are required for the approval/forms system
  validates :user_id, presence: true
  belongs_to :user, optional: true
  belongs_to :approval, optional: true

  validates :alert_type_id, presence: true
  belongs_to :alert_type, class_name: 'FieldDescriptor', foreign_key: :alert_type_id, optional: true

  def approval_completion
    self.approved = true
    self.save
  end

  def approval_denied
    # delete ?
    # self.destroy
  end
end
