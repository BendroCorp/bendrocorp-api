class FieldDescriptorClass < ApplicationRecord
  before_create do
    self.id = SecureRandom.uuid if id.nil? && ENV['RAILS_ENV'] != 'production'
  end
  
  validates :title, presence: true
  validates :class_name, presence: true
  validates :class_field, presence: true

  has_one :field

  def field_data
    # https://stackoverflow.com/questions/1407451/calling-a-method-from-a-string-with-the-methods-name-in-ruby
    # https://stackoverflow.com/questions/5924495/how-do-i-create-a-class-instance-from-a-string-name-in-ruby

    # get the class
    puts class_name
    clazz = class_name.constantize

    # check to see if the class has an ordinal or archived attribute
    has_ordinal = true if clazz.attribute_method? :ordinal
    has_archived = true if clazz.attribute_method? :archived
    has_approved = true if clazz.attribute_method? :approved

    # has an ordinal
    results = clazz.all.order('ordinal') if has_ordinal && !has_archived

    # has archived
    results = clazz.where(archived: false) if !has_ordinal && has_archived

    # has ordinal and archived
    results = clazz.where(archived: false).order('ordinal') if has_ordinal && has_archived

    # if it has approvals
    results = results.where(approved: true) if has_approved

    # TODO: Find a way to make this work
    # if restrict_by_owner
    #   results = results.map do |item|
    #     # return item if the id field
    #     item if item.instance_eval(owner_field_name) == current_user.id
    #   end
    # end

    # default fetch config
    results = clazz.all if !has_ordinal && !has_archived

    mapped_results = results.map do |item|
      if has_ordinal
        { id: item.id, title: item.instance_eval(class_field), created_at: item.created_at, ordinal: item.ordinal, field_id: field.id }
      else
        { id: item.id, title: item.instance_eval(class_field), created_at: item.created_at, field_id: field.id }
      end
    end

    mapped_results.sort! { |a, b| a[:ordinal] <=> b[:ordinal] } if has_ordinal
    mapped_results.sort! { |a, b| a[:created_at] <=> b[:created_at] } if !has_ordinal && self.sort_by_date
    mapped_results.sort! { |a, b| a[:title] <=> b[:title] } if !has_ordinal && !self.sort_by_date

    # return the results
    mapped_results
  end
end
