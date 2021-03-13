class ProfileGroup < ApplicationRecord
  has_paper_trail
  before_create :assign_depth
  before_create :set_ordinal

  validates :title, presence: true
  # validates :description, presence: true

  belongs_to :parent, class_name: 'ProfileGroup', foreign_key: :parent_id, optional: true
  has_many :children, class_name: 'ProfileGroup', dependent: :destroy, foreign_key: :parent_id

  # https://prograils.com/three-ways-iterating-tree-like-active-record-structures
  # https://github.com/ClosureTree/closure_tree/issues/50
  def assign_depth
    self.depth = (parent.present? ? parent.depth + 1 : 0)
  end

  def children_hash
    tree_depth = ProfileGroup.order(depth: :desc).first.depth || 0
    tree_depth.times.inject(:children) { |h| { children: h } }
  end

  def all_children
    children.flat_map do |child_cat|
      child_cat.all_children << child_cat
    end
  end

  def set_ordinal
    self.ordinal = ProfileGroupMember.where(archived: false).count + 1
  end
end
