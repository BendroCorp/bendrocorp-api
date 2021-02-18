require 'httparty'

class ApplicationsController < ApplicationController
  before_action :require_user
  before_action :require_member, except: [:fetch, :create] # :advance_application_status, :reject_application,

  before_action only: [:advance_application_status, :reject_application] do |a|
    a.require_one_role([9, 12])
  end

  # Create a new application
  # POST api/apply
  def create
    # make sure that the current user isn't already a member and that thier application hasn't already been logged
    if current_user.db_user.characters.count == 0
      @character = Character.new(application_character_params)
      # puts params[:character].inspect
      if Character.where('first_name = ? AND last_name = ?', @character.first_name, @character.last_name).count == 0
        @character.is_main_character = true
        @character.user_id = current_user.id

        # setup the actual application
        @character.application = Application.new(application_params)
        @character.application.application_status_id = 1
        @character.application.interview = ApplicationInterview.new # create the interview packet
        applicantjob = Job.find_by id: 21 # applicant job id - cause everyone starts as an applicant

        # add a job for the character
        @character.job_trackings << JobTracking.new(job: applicantjob)

        # update status change tracking
        @character.application.last_status_change = Time.now
        @character.application.last_status_changed_by_id = current_user.id

        # add the owned ship
        @character.owned_ships << OwnedShip.new(owned_ship_params)

        # update rsi_handle
        if params[:rsi_handle].nil?
          render status: 400, json: { message: 'You must provide your RSI handle.' }
          return
        end
        @character.user.rsi_handle = params[:rsi_handle].downcase

        page = HTTParty.get("https://robertsspaceindustries.com/citizens/#{@character.user.rsi_handle.downcase}")

        # Check to make sure the handle check passed
        if page.code == 200
          @offender = OffenderReportOffender.find_by offender_handle: @character.user.rsi_handle.downcase
          if !(@offender && @offender.offender_reports.count > 0)
            # try to save
            if @character.save
              SiteLog.create(module: 'Application', submodule: 'Application Success', message: "Application successfully created for #{@character.id}", site_log_type_id: 1)
              approver_ids = []
              User.where('is_member = ?', true).each do |user|
                approver_ids << user.id if user.isinrole(2) # executive role
                approver_ids << user.id if user.isinrole(13) && @character.application.job.division_id == 2 #user is in logistics director role and application job div is logistics
                approver_ids << user.id if user.isinrole(14) && @character.application.job.division_id == 3 #user is in security director role and application job div is security
                approver_ids << user.id if user.isinrole(15) && @character.application.job.division_id == 4 #user is in research director role and application job div is research
                approver_ids << user.id if user.isinrole(45) && @character.application.job.division_id == 7 #user is in medical director role and application job div is medical
              end

              # make sure there are no duplicates
              approver_ids.uniq!

              # create the new approval request
              approval_request = Applicantapproval_request.new

              approval_request.user_id = current_user.id

              begin
                # put the approval instance in the request
                approval_request.approval_id = new_approval(23, 0, 0, approver_ids, false) # applicant approval request
              rescue => e
                @character.destroy
                raise e
              end

              # lastly add the request to the current_user
              # approval_request.user = current_user # may not need to actually use this
              approval_request.application = @character.application

              @character.application.applicant_approval_request = approval_request
              if @character.save
                SiteLog.create(module: 'Application', submodule: 'Application Approval Creation Success', message: "Application approvals successfully created for #{@character.id}", site_log_type_id: 1)
                # mail Exec, Directors and HR
                # new application bosses notices
                boss_role_ids = [2, 3, 7]
                new_app_message = "#{@character.full_name} has just applied to be a member of BendroCorp. His application is available for review on the application tab on his profile."

                # push to group
                send_push_notification_to_groups(
                  boss_role_ids,
                  new_app_message,
                  apns_category: 'PROFILE_NOTICE',
                  data: { profile_id: character.id }
                )

                # email to group
                email_groups(boss_role_ids, "New Application", "#{@character.full_name} has just applied to be a member of BendroCorp. His application is available for review on the application tab on his profile.")
                render status: 200, json: @character.application.as_json(include: { application_status: { } })
              else
                puts @character.errors.full_messages.inspect
                SiteLog.create(module: 'Application', submodule: 'Application Save Failed', message: "Application could not be saved because: #{@character.errors.full_messages.inspect}", site_log_type_id: 3)
                render status: 500, json: { message: "There was a problem saving your application because: #{@character.errors.full_messages.to_sentence}" }
              end
            else
              puts @character.errors.full_messages.inspect
              SiteLog.create(module: 'Application', submodule: 'Application Save Failed', message: "Application could not be saved because: #{@character.errors.full_messages.inspect}", site_log_type_id: 3)
              render status: 500, json: { message: "There was a problem saving your application because: #{@character.errors.full_messages.to_sentence}" }
            end
          else
            render status: 400, json: { message: 'You are not eligible to apply to BendroCorp. There are currently outstanding offender reports against the provided player handle.' }
          end
        else
          render status: 400, json: { message: "RSI handle could not be verified. Please double check your entry." }
        end
      else
        render status: 400, json: { message: 'A character with the first and last name combination you entered already exists. Please enter another.' }
      end
    else
      render status: 400, json: { message: 'You already have a character under your account. If you are applying and encountered an error try refreshing the page.' }
    end
  end

  # PATCH api/apply
  def update_interview
    @interview = ApplicationInterview.find_by_id(params[:interview][:id])
    if @interview
      if @interview.update_attributes(application_interview_params)
        render status: 200, json: @interview
      else
        render status: 500, json: { message: "The application interview could not be updated because: #{@interview.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: "Interview not found!" }
    end
  end

  # GET api/apply
  def fetch
    if current_user.main_character
      render status: 200, json: current_user.main_character.application.as_json(include: { application_status: { } })
    else
      render status: 404, json: { message: 'Your currently do not have a character!' }
    end
  end

  # DELETE api/apply
  def withdraw_application
    db_user = current_user.db_user
    if !db_user.member? # members should not be able to do this
      db_user.characters.each do |char|
        job = Job.find_by_id(24) # withdrawn job
        char.jobs << job
        char.application.application_status_id = 8 # withdrawn status
      end
      if db_user.save
        email_groups([2,3,7], "Application Withdrawn", "#{@character.main_character.full_name} has withdrawn their application to be a member of BendroCorp.")
        # flash[:success] = "Application withdrawn successfully."
        # redirect_to '/'
        render status: 200, json: { message: 'Application withdrawn successfully.' }
      else
        # flash[:danger] = "There was an error withdrawing your application."
        # redirect_to '/'
        render status: 500, json: { message: "There was a problem withdrawing your application because: #{@character.errors.full_messages.to_sentence}" }
      end
    else
      render status: 400, json: { message: 'Members cannot withdraw a membership application.' }
    end
  end

  def reapply
    # TODO
  end

  # GET /api/apply/:character_id/advance
  def advance_application_status
    @character = Character.find_by_id(params[:character_id])
    if @character != nil
      # aka does not already has a completed status
      # ...and the user is not under Executive Review
      # ...only an admin can actually except an application
      if @character.application.application_status_id < 6 && (@character.application.application_status_id != 5 || current_user.isinrole(9))
        @character.application.application_status_id += 1

        if @character.application.application_status_id == 4 && !@character.application.interview.locked_for_review

          render status: :unprocessable_entity, json: { message: 'Cannot advance application to Executive Review until the application interview is locked for final review.' }
        elsif @character.application.application_status_id == 5 && @character.application.applicant_approval_request.approval.approval_approvers.where('approval_type_id < ?', 4).count > 0
          render status: :unprocessable_entity, json: { message: 'Cannot advance application to CEO Review until all approvers have submitted their approval acceptance or rejection.' }
        elsif @character.application.application_status_id == 6 && !current_user.isinrole(9)
          render status: :unprocessable_entity, json: { message: 'Only the person in the CEO role can advance (accept) this application.' }
        else
          #if the applicant's new status is 6 then flip the is_member flag on their user to true
          if @character.application.application_status_id == 6
            @character.jobs << @character.application.job
            @character.user.is_member = true
            @character.user.roles << Role.find_by_id(0)

            # remove specific non-member roles
            # (ie. client and applicant)
            old_roles = @character.user.in_roles.where('role_id IN (-2, -3)')
            old_roles.destroy_all
          end

          @character.application.last_status_change = Time.now
          @character.application.last_status_changed_by_id = current_user.id
          #err
          if @character.save

            # email the user
            send_email(@character.user.email, "Application Status Update",
            "<p>Hello #{@character.user.username}!</p><p>Your application status has been changed to: <strong>#{@character.application.application_status.title}</strong></p><p>#{@character.application.application_status.description}</p>"
            ) #to, subject, message

            # push for the user
            send_push_notification(@character.user_id, "Your application status has been changed to: #{@character.application.application_status.title}")

            # email hr, directors and execs with the updated status
            email_groups([2, 3, 7], "Application Status Update for #{@character.full_name}",
            "<p>#{@character.user.username}'s application status for #{@character.full_name} has been changed to: <strong>#{@character.application.application_status.title}</strong></p><p>#{@character.application.application_status.description}</p>"
            )

            # push for execs
            # push to group
            send_push_notification_to_groups(
              [2, 3, 7],
              "#{@character.user.username}'s application status for #{@character.full_name} has been changed to: #{@character.application.application_status.title}",
              apns_category: 'PROFILE_NOTICE',
              data: { profile_id: character.id }
            )

            # if application level is 4 (ie. Executive Review) send out approval notices to those who have NOT yet responded
            if @character.application.application_status_id == 4
              needed_approvals = @character.application.applicant_approval_request.approval.approval_approvers.where('approval_type_id < ?', 4)
              if needed_approvals.count > 0
                needed_approvals.each do |approver|
                  # change the approval approver required to true
                  approver.required = true
                  approver.save
                  # send email
                  send_email(approver.user.email, "Application Approval Requested",
                  "<p>Hello #{approver.user.username}!</p><p>The application for <strong>#{@character.full_name}</strong> requires your approval (Accepted or Declined) please submit below.</p>"
                  ) #to, subject, message
                end
              end
            end

            # Kaden announce started 360 review
            if @character.application.application_status_id == 2
              send_push_notification_to_members(
                "A '360' Review has started for #{@character.full_name}. Please leave your feedback on the applicant!",
                apns_category: 'VIEW_APPLICATION',
                data: { profile_id: character.id }
              )
              KaidenAnnounceWorker.perform_async("A '360' Review has started for #{@character.full_name}. Please head over to https://bendrocorp.app/profiles/#{@character.id} and tap on the Application section to leave your feedback on the applicant!")
            end

            # Kaden announce ended 360 review
            if @character.application.application_status_id == 3
              send_push_notification_to_members(
                "The '360' Review for #{@character.full_name} has been closed. Thank you to everyone who participated!",
                apns_category: 'PROFILE_NOTICE',
                data: { profile_id: character.id }
              )
              KaidenAnnounceWorker.perform_async("The '360' Review for #{@character.full_name} has been closed. Thank you to everyone who participated!")
            end

            if @character.application.application_status_id == 6
              send_push_notification_to_members(
                "#{@character.full_name} has been accepted as a member of BendroCorp. Everyone please make sure to give a warm welcome!",
                apns_category: 'PROFILE_NOTICE',
                data: { profile_id: character.id }
              )
              KaidenAnnounceWorker.perform_async("#{@character.full_name} has been accepted as a member of BendroCorp. Everyone please make sure to give a warm welcome!")
            end

            render status: 200, json: { message: 'Successfully updated application status!' }
          else
            # err
            # flash[:danger] = "Application status could not be updated."
            # redirect_to action: "personnel_view", id: @character.id
            render status: 500, json: { message: "Application status could not be updated because: #{@character.errors.full_messages.to_sentence}" }
          end
        end #end status 4 check
      else
        # flash[:warning] = "This character's application already has a completed status attached to it or you do not have the required permissions to advance the application at this stage."
        # redirect_to action: "personnel_view", id: @character.id
        render status: 400, json: { message: "This character's application already has a completed status attached to it or you do not have the required permissions to advance the application at this stage." }
      end
    else
      # flash[:danger] = "Character not found."
      # redirect_to :action => "index"
      render status: 404, json: { message: 'Character not found' }
    end
  end
  #end personnel section

  # POST /api/apply/reject
  def reject_application
    @character = Character.find_by_id(params[:character][:id])
    if @character != nil
      if params[:character][:application][:rejection_reason] != nil
        @character.application.application_status_id = 7
        # find the job
        job = Job.find_by_id(23) # TODO: Add a Declined role - discharged will work for now
        @character.jobs << job
        @character.application.rejection_reason = params[:character][:application][:rejection_reason]
        if @character.save
          send_email(@character.user.email, 'Application Status Update',
          "<p>Hello #{@character.user.username}!</p><p>Your application status has been changed to: <strong>#{@character.application.application_status.title}</strong></p><p>#{@character.application.application_status.description}</p><p>Your application was rejected for the following reason:</p><p>#{params[:character][:application][:rejection_reason]}</p>"
          )

          # Close the approval
          @approval = @character.application.applicant_approval_request.approval

          # Change the approval type to not needed
          @approval.approval_approvers.where("approval_type_id < 4").to_a.each do |approver|
            approver.approval_type_id = 6
            approver.save!
          end

          # auto deny the approval
          @approval.denied = true

          if @approval.save
            render status: 200, json: { message: 'Application successfully rejected!' }
          else
            render status: 500, json: { message: "Application could not be rejected because: #{@approval.errors.full_messages.to_sentence}" }
          end

        else
          # redirect_to action: "personnel_view", id: @character.id
          render status: 500, json: { message: "Application status could not be updated because: #{@character.errors.full_messages.to_sentence}" }
        end
      else
        render status: 400, json: { message: 'Application rejection reason not supplied! You must include a rejection reason!' }
      end
    else
      # flash[:danger] = "Character not found."
      # redirect_to :action => "index"
      render status: 404, json: { message: 'Character not found!' }
    end
  end

  private
  def application_character_params
    params.require(:character).permit(:first_name, :last_name, :description, :background) #, user_attributes: [:rsi_handle], owned_ships_attributes: [:ship_id, :title], application_attributes: [:tell_us_about_the_real_you, :why_do_want_to_join, :how_did_you_hear_about_us, :job_id, :rejection_reason])
  end

  def application_params
    params.require(:new_application).permit(:why_do_want_to_join, :how_did_you_hear_about_us, :job_id)
  end

  def owned_ship_params
    params.require(:owned_ship).permit(:ship_id, :title)
  end

  private
  def application_interview_params
    params.require(:interview).permit(:tell_us_about_yourself,
      :applicant_has_read_soc,
      :applicant_agrees_to_respect_for_leadership,
      :applicant_agrees_to_voice_policy,
      :applicant_agrees_to_roleplay_style,
      :applicant_agrees_to_follow_all_policies,
      :applicant_agrees_to_understands_participation,
      :why_selected_division,
      :why_join_bendrocorp,
      :applicant_questions,
      :interview_consensous,
      :locked_for_review)
  end
end
