class FieldDescriptorClass < ApplicationRecord
  before_create do
    self.id = SecureRandom.uuid if id.nil? && ENV['RAILS_ENV'] != 'production'
  end
  
  validates :title, presence: true
  validates :class_name, presence: true
  validates :class_field, presence: true

  def field_data
    # https://stackoverflow.com/questions/1407451/calling-a-method-from-a-string-with-the-methods-name-in-ruby
    # https://stackoverflow.com/questions/5924495/how-do-i-create-a-class-instance-from-a-string-name-in-ruby

    # get the class
    clazz = class_name.constantize

    # check to see if the class has an ordinal or archived attribute
    has_ordinal = true if clazz.attribute_method? :ordinal
    has_archived = true if clazz.attribute_method? :archived

    # has an ordinal
    results = clazz.all.order('ordinal') if !has_ordinal && has_archived

    # has archived
    results = clazz.where(archived: false) if !has_ordinal && has_archived

    # has ordinal and archived
    results = clazz.where(archived: false).order('ordinal') if has_ordinal && has_archived

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
        { id: item.id, title: item.instance_eval(class_field), ordinal: item.ordinal }
      else
        { id: item.id, title: item.instance_eval(class_field) }
      end
    end

    mapped_results.sort! { |a, b| a[:ordinal] <=> b[:ordinal] } if has_ordinal
    mapped_results.sort! { |a, b| a[:title] <=> b[:title] } if !has_ordinal

    # return the results
    mapped_results
  end
end
