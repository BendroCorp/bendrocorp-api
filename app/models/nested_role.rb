class NestedRole < ApplicationRecord
  # http://www.spacevatican.org/2008/5/6/creating-multiple-associations-with-the-same-table/
  belongs_to :role, :class_name => 'Role', :foreign_key => 'role_id'
  belongs_to :role_nested, :class_name => 'Role', :foreign_key => 'role_nested_id'
end
