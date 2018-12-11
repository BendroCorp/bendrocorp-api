class TrainingController < ApplicationController
  before_action :require_user, except: []
  before_action :require_member, except: []

  before_action except: [:list_courses, :fetch_types, :fetch_course, :complete_training_item] do |a|
    a.require_one_role([35]) # training editor
  end

  # GET api/training
  def list_courses
    if !current_user.isinrole(35)
      render status: 200, json: TrainingCourse.where(archived: false, draft: false).as_json(include: { badge: { }, training_course_completions: { }, training_items: { except: [:syllabus_link], include: { training_item_completions: { }, training_item_type: { },  created_by: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } })
    else
      render status: 200, json: TrainingCourse.where(archived: false).as_json(include: { badge: { }, training_course_completions: { }, training_items: { include: { training_item_completions: { }, training_item_type: { },  created_by: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } })
    end
  end

  # GET api/training/types
  def fetch_types
    render status: 200, json: TrainingItemType.all
  end

  # GET api/training/badges
  def fetch_badges
    render status: 200, json: Badge.all
  end

  # GET api/training/instructors
  def fetch_instructors
    @users = Role.find_by_id(36).role_full_users
    render status: 200, json: @users.as_json(only: [], methods: [:main_character])
  end

  # GET api/training/:course_id
  def fetch_course
    @course = TrainingCourse.find_by(id: params[:course_id].to_i, archived: false)
    if @course
      render status: 200, json: @course.as_json(include: { training_items: { training_course_completions: { }, include: { training_item_completions: { }, training_item_type: { },  created_by: { only: [:id], methods: [:main_character] } } }, created_by: { only: [:id], methods: [:main_character] } })
    else
      render status: 404, json: { message: 'Course not found!' }
    end
  end

  # POST api/training/
  def create_course
    @course = TrainingCourse.new(training_course_params)
    @course.version = 1
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
    @course.version += 1
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

  # DELETE api/training/:training_course_id
  def archive_course
    @course = TrainingCourse.find_by_id(params[:course_id])
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
    @item.version = 1
    @item.training_course.version += 1
    @item.ordinal = @item.training_course.training_items.count + 1

    if @item.save
      render status: 200, json: @item.as_json(include: { training_item_completions: { }, training_item_type: { },  created_by: { only: [:id], methods: [:main_character] } } )
    else
      render status: 500, json: { message: "The training item could not be created because: #{@item.errors.full_messages.to_sentence}" }
    end
  end

  # PUT|PATCH api/training/item
  def update_training_item
    @item = TrainingItem.find_by_id(params[:training_item][:id].to_i)
    if @item
      @item.version += 1
      @item.training_course.version += 1
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
    @item = TrainingItem.find_by_id(params[:training_item_id].to_i)
    if @item
      @item.training_course.version += 1
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

    @completion.user = current_user
    @completion.completed = true if @completion.training_item.training_item_type.id != 4
    @completion.item_version = @completion.training_item.training_course.version # course version

    if @completion.training_item.training_course.draft == false
      if @completion.save
        if @completion.training_item.training_item_type.id != 4
          # check to see if the users has a completion for all training items
          puts "#{@completion.training_item.training_course.inspect}"
          @course = TrainingCourse.find_by_id(@completion.training_item.training_course)
          completed_count = 0
          @course.training_items.each { |item| completed_count += 1 if item.user_did_complete current_user }

          # if the training item count matches the completion count then the user finished everything
          if completed_count >= @course.training_items.count
            @c_completion = TrainingCourseCompletion.new(user: current_user, training_course: @course, version: @course.version)
            if @c_completion.save
              # Then finally award the badge, if one exists
              if @course.badge && current_user.badges.where(id: @course.badge_id).count == 0
                current_user.badges << @course.badge
                current_user.save!
                render status: 200, json: @c_completion
              end
            else
              raise "Error: Could not create course completion for course_id #{@course.id} for #{current_user.main_character.full_name}"
            end
          else
            render status: 200, json: @completion
          end
        else
          # then we need to make an approval request
          #Create the new approval request
          approvalRequest = TrainingItemCompletionRequest.new
          # put the approval instance in the request
          approvalRequest.approval_id = new_approval(24) # offender report approval

          # adjust the consent requirements
          approvalRequest.approval.full_consent = false
          approvalRequest.approval.single_consent = true

          # lastly add the request to the current_user
          approvalRequest.user = current_user

          approvalRequest.training_item_completion = @completion

          if approvalRequest.save
            render status: 200, json: @completion
          end
        end
      else
        render status: 500, json: { message: "The training item completion could not be created because: #{@completion.errors.full_messages.to_sentence}" }
      end
    else
        render status: 400, json: { message: 'You cannot complete a course item for a course that is a draft!' }
    end
  end

  private
  def training_course_params
    params.require(:training_course).permit(:title, :description, :badge_id, :draft, :required)
  end

  private
  def training_item_params
    params.require(:training_item).permit(:title, :text, :link, :syllabus_link, :video_link, :training_course_id, :training_item_type_id, :ordinal)
  end

  private
  def training_item_completion_params
    params.require(:training_item_completion).permit(:training_item_id)
  end
end
