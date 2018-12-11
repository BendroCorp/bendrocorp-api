require 'sidekiq-scheduler'

class RequiredCourseWorker
  include Sidekiq::Worker

  def perform(*args)
    User.all.each do |user|
      if user.is_member?
        todos = []
        # TODO: Support division specific course requirements
        TrainingCourse.where(archived: false, required: true).each do |course|
          todo << course if course.training_course_completions.where(user: user, version: course.version).count == 0
        end

        mailTodoString = "<p>"
        todos.each do |todo|
          mailTodoString = "#{mailTodoString}</br><a href='https://my.bendrocorp.com/training/#{todo.id}'>#{todo.title}</a>"
        end
        mailTodoString = "#{mailTodoString}</p>"

        EmailWorker.perform_async user.email, "Missing Required Courses", "<p>Hello #{user.main_character.full_name}</p><p>You currently have outstanding required courses:</p>#{mailTodoString}"
      end
    end
  end
end
