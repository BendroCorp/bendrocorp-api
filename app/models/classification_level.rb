class ClassificationLevel < ApplicationRecord
  has_many :classification_levels
  has_many :roles, through: :classification_levels

  def has_roles
    if self.roles > 0
      true
    else
      false
    end
  end
end
