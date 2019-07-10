class TrainingItemCompletionRequest < ApplicationRecord
  validates :user_id, presence: true
  belongs_to :user, optional: true #required field/fk
  belongs_to :approval #required field/fk
  belongs_to :training_item_completion

  accepts_nested_attributes_for :approval
  accepts_nested_attributes_for :training_item_completion
  accepts_nested_attributes_for :user

  def approval_completion #what happens when the approval is approved
    @completion = self.training_item_completion
    @completion.completed = true
    if @completion.save
      # check to see if the users has a completion for all training items
      puts "#{@completion.training_item.training_course.inspect}"
      @course = TrainingCourse.find_by_id(@completion.training_item.training_course)
      completed_count = 0
      @course.training_items.each { |item| completed_count += 1 if item.user_did_complete self.user }

      # if the training item count matches the completion count then the user finished everything
      if completed_count >= @course.training_items.count
        @c_completion = TrainingCourseCompletion.new(user: self.user, training_course: @course, version: @course.version)
        if @c_completion.save
          # Then finally award the badge, if one exists
          if @course.badge && self.user.badges.where(id: @course.badge_id).count == 0
            self.user.badges << @course.badge
            self.user.save!
            # render status: 200, json: @c_completion
          end
        else
          raise "Error: Could not create course completion for course_id #{@course.id} for #{self.user.main_character.full_name}"
        end
      else
        # render status: 200, json: @completion
      end
    else
      raise "The training item completion could not be created because: #{@completion.errors.full_messages.to_sentence}"
    end
  end

  def approval_denied #what happens when the approval is denied
  end
end
