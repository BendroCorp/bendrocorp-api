class Role < ActiveRecord::Base
  has_many :in_roles
  has_many :users, through: :in_roles

  # Kind of like groups of roles with a cooler name
  has_many :classification_level_roles
  has_many :classification_levels, through: :classification_level_roles

  has_many :approver_roles
  has_many :approval_kinds, through: :approver_roles

  has_many :nested_roles, :class_name => 'NestedRole', :foreign_key => 'role_id'

  def role_users
    users = []
    User.all.each do |user|
      users << user.username if user.isinrole(self.id)
    end
    users
  end

  def role_full_users
    users = []
    User.all.each do |user|
      users << user if user.isinrole(self.id)
    end
    users
  end
end
