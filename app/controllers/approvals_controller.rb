class ApprovalsController < ApplicationController
  before_action :require_user
  before_action :require_member

  # get api/approvals/:approval_id/:approval_type
  def approval_request
    #@your_approval = ApprovalApprover.find_by id: params[:approval_id].to_i
    @your_approval = ApprovalApprover.where("approval_id = ? AND user_id = ?", params[:approval_id].to_i, current_user.id).first #find_by id: params[:approval_id].to_i
    if @your_approval != nil
      @approval = @your_approval.approval
      if @your_approval.user.id == current_user.id #approvals can only be made by the from whom they are requested
        if @your_approval.approval_type_id < 4 && (params[:approval_type].to_i == 4 || params[:approval_type].to_i == 5)
          @your_approval.approval_type_id = params[:approval_type].to_i

          if @your_approval.save!
            # check and see if we should update the parental approver status
            # first check to see if all of the approver have weighed in
            # full consent meta workflow
            if @your_approval.approval.approval_approvers.where("approval_type_id > 3").count >= 1 && !@approval.single_consent
              # if we have all of the results in
              @approval = @your_approval.approval

              approversCount = @approval.approval_approvers.count
              approved = @approval.approval_approvers.where("approval_type_id = 4").count
              denied = @approval.approval_approvers.where("approval_type_id = 5").count

              if denied > 0 # for full consent if any one denies then the approval has failed. So no need to keep going. ;)
                @approval.denied = true
                # Change the status of unsubmitted approvals to not needed
                @approval.approval_approvers.where("approval_type_id < 4").to_a.each do |approver|
                  approver.approval_type_id = 6
                  approver.save!
                end
              elsif approved >= approversCount #
                @approval.approved = true
              elsif approved < approversCount
                # then do nothing becuase we dont have full consent yet
              else
                raise 'Approval consent out of range!'
              end

              if @approval.save

                # run final workflows
                run_approval_workflow @approval

                render status: 200, json: { message: "Approval status changed." }
              else
                render status: 500, :json => { message: "The approval could not be completed." }
              end

            # single consent meta workflow
            elsif @your_approval.approval.approval_approvers.where("approval_type_id > 3").count >= 1 && @approval.single_consent
              # re-fetch the approval
              @approval = @your_approval.approval

              # it only takes one person to approve this approval
              if @approval.approval_approvers.where("approval_type_id = 4").count >= 1
                @approval.approved = true
                # Change the status of unsubmitted approvals to not needed
                @approval.approval_approvers.where("approval_type_id < 4").to_a.each do |approver|
                  approver.approval_type_id = 6
                  approver.save!
                end

              elsif @approval.approval_approvers.where("approval_type_id = 5").count == @approval.approval_approvers.count
                @approval.denied = true
              else
                raise 'Approval out of range (2)'
              end
              if @approval.approved == true || @approval.denied == true
                if @approval.save
                  # if the approval saves then run the completion function

                  # run final workflows
                  run_approval_workflow @approval

                  render status: 200, json: { message: "success" }
                else
                  render status: 500, :json => { message: "The approval could not be completed." }
                end
              else
                render status: 200, :json => { message: "Approval updated." }
              end
            else
              render status: 200, :json => { message: "Approval updated." }
            end
          else
            render status: 500, :json => { message: "Approval could not be saved." }
          end
        else
          puts "Approval type not valid - Current Type Id: #{@your_approval.approval_type_id} - Incoming Type Id #{params[:approval_type]}"
          render status: 500, :json => { message: "Selected approval type not valid" }
        end
      else
        render status: 403, :json => { message: "You are not authorized to change the status of this approval." }
      end
    else
      render status: 404, :json => { message: "Approval does not exist..." }
    end
  end

  # get api/approvals/pending/
  def pending_approval_count
    if current_user.isinrole(9)
      @pending_approval_count = (Approval.where denied: false, approved: false).count
      render status: 200, json: { count: @pending_approval_count }
    else
      render status: 403, json: { message: 'You are not authorized to use this endpoint!' }
    end
  end

  # post api/approvals/override/
  # This override endpoint is meant for broad use to clear the queue. Should be used with great care!
  def approval_override
    if current_user.isinrole(9) # only the CEO may use this endpoint
      if current_user.two_factor_valid params[:code].to_i # must use two factor to use this method
        @approvals = Approval.where denied: false, approved: false
        @approvals.each do |approval|
          @approvers = approval.approval_approvers.where('approval_type_id < 4')
          @approvers.each do |approver|
            approver.approval_type_id = 6 # feedback not needed
            approver.save!
          end

          # set approval to approved
          @approval.approved = true

          if @approval.save
            # notify the approvers of the status of the approval
            @approvers.to_a.each do |approver|
              approverPushText = "NOTICE: Approval ##{@approval.id} #{@approval.approval_kind.title} has been approved via CEO override and your feedback is no longer needed."
              approverEmailText = "<p>#{approver.user.main_character.first_name},</p><p>Approval ##{@approval.id} #{@approval.approval_kind.title} to which you are an approver has been approved via override by the CEO and your feedback is no longer needed.</p><p>#{@approval.approval_approvers.map { |approver_inner| "#{approver_inner.user.main_character.full_name}: #{approver_inner.approval_type.title}" }.join('<br>')}</p>"

              send_push_notification approver.user.id, approverPushText
              send_email approver.user.email, "Approval Overriden", approverEmailText
            end

            # run the completetion workflow
            run_approval_workflow @approval
          end
        end

        # return 200 ok
        render status: 200, json: { message: 'Completed approval overrides!' }
      else
        render status: 403, json: { message: 'Improper authorization code provided!' }
      end
    else
      render status: 403, json: { message: 'You are not authorized to use this endpoint!' }
    end
  end

  # post 'api/approvals/override/:approval_id'
  # Body contains :code, approval_type_id
  def approval_override_specific
    if current_user.isinrole(9) # only the CEO may use this endpoint
      if current_user.two_factor_valid params[:code].to_i # must use two factor to use this method
        @approval = Approval.where(denied: false, approved: false, id: params[:approval_id].to_i).first
        if @approval
          @approvers = approval.approval_approvers.where('approval_type_id < 4')
          @approvers.each do |approver|
            approver.approval_type_id = 6 # feedback not needed
            approver.save!
          end

          # set approval to approved
          # @approval.approved = true
          if params[:approval_type_id] == 4
            @approval.approved = true
            @approval.denied = false
          elsif params[:approval_type_id] == 5
            @approval.approved = false
            @approval.denied = true
          end

          if @approval.save
            # notify the approvers of the status of the approval
            @approvers.to_a.each do |approver|
              approverPushText = "NOTICE: Approval ##{@approval.id} #{@approval.approval_kind.title} has been completed via CEO override and your feedback is no longer needed."
              approverEmailText = "<p>#{approver.user.main_character.first_name},</p><p>Approval ##{@approval.id} #{@approval.approval_kind.title} to which you are an approver has been completed via override by the CEO and your feedback is no longer needed.</p><p>#{@approval.approval_approvers.map { |approver_inner| "#{approver_inner.user.main_character.full_name}: #{approver_inner.approval_type.title}" }.join('<br>')}</p>"

              send_push_notification approver.user.id, approverPushText
              send_email approver.user.email, "Approval Overriden", approverEmailText
            end

            # run the completetion workflow
            run_approval_workflow @approval

            # return 200 ok
            render status: 200, json: { message: 'Completed approval overrides!' }
          end
        else
          render status: 404, json: { message: 'Approval not found or the approval has already been approved or denied!'}
        end
      else
        render status: 403, json: { message: 'Improper authorization code provided!' }
      end
    else
      render status: 403, json: { message: 'You are not authorized to use this endpoint!' }
    end
  end

  # GET api/approval/types
  def approval_types
    render status: 200, json: ApprovalType.all
  end

  # handles the approval approved and denied workflows
  private
  def run_approval_workflow approval
    # run the normal approval workflow
    if approval.approved && !approval.denied
      # TODO: Data drive this more!!
      if approval.approval_workflow == 1 # standard workflow
        # push notification to the approval creator
        send_push_notification approval.approval_source.user.id, "Approval ##{approval.id} #{approval.approval_kind.title} Approved"

        # notify the approvers of the status of the approval
        approval.approval_approvers.to_a.each do |approver|
          approverPushText = "Approval ##{approval.id} #{approval.approval_kind.title} has been approved!"
          approverEmailText = "<p>#{approver.user.main_character.first_name},</p><p>Approval ##{approval.id} #{approval.approval_kind.title} to which you are an approver has been approved.</p><p>#{approval.approval_approvers.map { |approver_inner| "#{approver_inner.user.main_character.full_name}: #{approver_inner.approval_type.title}" }.join('<br>')}</p>"

          send_push_notification approver.user.id, approverPushText
          send_email approver.user.email, "Approval Approved", approverEmailText
        end

        # email the user here
        send_email(approval.approval_source.user.email, "#{approval.approval_kind.title} Approved",
        "<p>Hello #{approval.approval_source.user.username}!</p><p>Your #{approval.approval_kind.title} for #{approval.approval_source_requested_item} has been approved.</p>"
        ) #to, subject, message
        approval.approval_source.approval_completion
      elsif approval.approval_workflow == 2 # applicant workflow
        # email exec group
        subject = 'Application approvals completed'
        message = "#{subject} for #{approval.approval_source.application.character.full_name}. This application can be advanced to the CEO Review stage once all other previous stages are completed."
        email_groups([2], subject, message)
      elsif approval.approval_workflow == 3 # do nothing workflow
        # do nothing
      end
    else # if the approval was denied
      # push notification to the approval creator
      send_push_notification approval.approval_source.user.id, "Approval ##{approval.id} #{approval.approval_kind.title} Denied"

      # notify the approvers of the denial
      # notify the approvers of the status of the approval
      approval.approval_approvers.to_a.each do |approver|
        approverPushText = "Approval ##{approval.id} #{approval.approval_kind.title} has been denied!"
        approverEmailText = "<p>#{approver.user.main_character.first_name},</p><p>Approval ##{approval.id} #{approval.approval_kind.title} to which you are an approver has been denied.</p><p>#{approval.approval_approvers.map { |approver_inner| "#{approver_inner.user.main_character.full_name}: #{approver_inner.approval_type.title}" }.join('<br>')}</p>"

        send_push_notification approver.user.id, approverPushText
        send_email approver.user.email, "Approval Approved", approverEmailText
      end

      # email the user that the request was denied
      send_email(approval.approval_source.user.email, "#{approval.approval_kind.title} Denied",
      "<p>Hello #{approval.approval_source.user.username}!</p><p>Your #{approval.approval_kind.title} for #{approval.approval_source_requested_item} has been denied. You can view your request from the relevant request page to get more information.</p>"
      ) #to, subject, message
      approval.approval_source.approval_denied
    end
  end
end
