class TrainingController < ApplicationController
  before_action :require_user, except: []
  before_action :require_member, except: []

  before_action except: [] do |a|
    a.require_one_role([35]) # training editor
  end

  # GET api/training
  def list_courses
    render status: 200, json: TrainingCourse.where(archived: false).as_json(include: { training_items: { include: { training_item_completions: { }, training_item_type: { },  created_by: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } })
  end

  # GET api/training/:course_id
  def fetch_course
    @course = TrainingCourse.find_by_id(params[:course_id].to_i)
    if @course
      render status: 200, json: @course.as_json(include: { training_items: { include: { training_item_completions: { }, training_item_type: { },  created_by: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } })
    else
      render status: 404, json: { message: 'Course not found!' }
    end
  end

  # POST api/training/
  def create_course
    @course = TrainingCourse.new(training_course_params)
    @course.created_by = current_user
    if @course.save
      render status: 200, json: @course.as_json(include: { training_items: { include: { training_item_completions: { }, training_item_type: { },  created_by: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } })
    else
      render status: 500, json: { message: "The course could not be created because: #{@course.errors.full_messages.to_sentence}" }
    end
  end

  # PATCH|PUT api/training/
  def update_course
    @course = TrainingCourse.find_by_id(params[:training_course][:id])
    if @course
      if @course.update_attributes(training_course_params)
        render status: 200, json: @course.as_json(include: { training_items: { include: { training_item_completions: { }, training_item_type: { },  created_by: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } })
      else
        render status: 500, json: { message: "The course could not be updated because: #{@course.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Course not found!' }
    end
  end

  # DELETE api/training/:course_id
  def archive_course
    @course = TrainingCourse.find_by_id(params[:training_course][:id])
    if @course
      @course.archived = true
      if @course.save
        render status: 200, json: @course.as_json(include: { training_items: { include: { training_item_completions: { }, training_item_type: { },  created_by: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } })
      else
        render status: 500, json: { message: "The course could not be archived because: #{@course.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Course not found!' }
    end
  end

  # POST api/training/item
  def create_training_item
    @item = TrainingItem.new(training_item_params)
    @item.created_by = current_user
    if @item.save
      render status: 200, json: @item.as_json(include: { training_item_completions: { }, training_item_type: { },  created_by: { only: [:id], methods: [:main_character] } } )
    else
      render status: 500, json: { message: "The training item could not be created because: #{@item.errors.full_messages.to_sentence}" }
    end
  end

  # PUT|PATCH api/training/item
  def update_training_item
    @item = TrainingItem.find_by_id(params[:training_item][:id])
    if @item
      if @item.update_attributes(training_item_params)
        render status: 200, json: @item.as_json(include: { training_item_completions: { }, training_item_type: { },  created_by: { only: [:id], methods: [:main_character] } } )
      else
        render status: 500, json: { message: "The training item could not be updated because: #{@item.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Training item not found!' }
    end
  end

  # DELETE api/training/item/:training_item_id
  def archive_training_item
    @item = TrainingItem.find_by_id(params[:training_item_id])
    if @item
      @item.archived = true
      if @item.save
        render status: 200, json: @item.as_json(include: { training_item_completions: { }, training_item_type: { },  created_by: { only: [:id], methods: [:main_character] } } )
      else
        render status: 500, json: { message: "The training item could not be archived because: #{@item.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Training item not found!' }
    end
  end

  # POST api/training/item/complete
  def complete_training_item
    @completion = TrainingItemCompletion.new(training_item_completion_params)
    if @completion.save
      # check to see if the users has a completion for all training items
      @course = TrainingCourse.find_by_id(@completion.training_item.training_course)
      completed_count = 0
      @course.training_items.each { |item| completed_count += 1 if item.user_did_complete current_user }

      # if the training item count matches the completion count then the user finished everything
      if @course.training_items.count >= completed_count
        @c_completion = TrainingCourseCompletion.new(user: current_user, training_course: @course)
        if @c_completion.save
          # Then finally award the badge, if one exists
          if @course.badge
            current_user.badges << @course.badge
            current_user.save!
            render status: 200, json: @completion
          end
        else
          raise "Error: Could not create course completion for course_id #{@course.id} for #{current_user.main_character.full_name}"
        end
      else
        render status: 200, json: @completion
      end
    else
      render status: 500, json: { message: "The training item completion could not be created because: #{@item.errors.full_messages.to_sentence}" }
    end
  end

  private
  def training_course_params
    params.require(:training_course).permit(:title, :description, :badge)
  end

  private
  def training_item_params
    params.require(:training_item).permit(:title, :text, :link, :video_link, :training_course_id, :training_item_type_id)
  end

  private
  def training_item_completion_params
    params.require(:training_item_completion).permit(:user_id, :training_item_id)
  end
end
