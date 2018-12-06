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

          if @your_approval.save
            #check and see if we should update the parental approver status
            #first check to see if all of the approver have weighed in
            if @your_approval.approval.approval_approvers.where("approval_type_id > 3").count >= @approval.approval_approvers.count && !@approval.single_consent
              # if we have all of the results in
              @approval = @your_approval.approval
              approversCount = @approval.approval_approvers.count
              approved = @approval.approval_approvers.where("approval_type_id = 4").count
              #denied = @approval.approval_approvers.where("approval_type_id == 5").count

              if (approversCount != approved) && @approval.full_consent
                @approval.denied = true
              elsif (approversCount == approved) && @approval.full_consent
                @approval.approved = true
              elsif ((approved * 100) / approversCount) >= 66 && !@approval.full_consent
                @approval.approved = true
              elsif ((approved * 100) / approversCount) < 66 && !@approval.full_consent
                @approval.denied = true
              else
                raise 'Approval consent out of range!'
              end

              if @approval.save
                # if the approval saves then run the completion function
                if @approval.approved
                  # TODO: Data drive this more!!
                  if @approval.approval_workflow == 1 # standard workflow
                    # push notification
                    send_push_notification @approval.approval_source.user.id, "Approval ##{@approval.id} #{@approval.approval_kind.title} Approved"

                    # email the user here
                    send_email(@approval.approval_source.user.email, "#{@approval.approval_kind.title} Approved",
                    "<p>Hello #{@approval.approval_source.user.username}!</p><p>Your #{@approval.approval_kind.title} for #{@approval.approval_source_requested_item} has been approved.</p>"
                    ) #to, subject, message
                    @approval.approval_source.approval_completion
                  elsif @approval.approval_workflow == 2 # applicant workflow
                    # email exec group
                    subject = 'Application approvals completed'
                    message = "#{subject} for #{@approval.approval_source.application.character.full_name}. This application can be advanced to the CEO Review stage once all other previous stages are completed."
                    email_groups([2], subject, message)
                  elsif @approval.approval_workflow == 3 # do nothing workflow
                    # do nothing
                  end
                else
                  # push notification
                  send_push_notification @approval.approval_source.user.id, "Approval ##{@approval.id} #{@approval.approval_kind.title} Denied"

                  # email the user that the request was denied
                  send_email(@approval.approval_source.user.email, "#{@approval.approval_kind.title} Denied",
                  "<p>Hello #{@approval.approval_source.user.username}!</p><p>Your #{@approval.approval_kind.title} for #{@approval.approval_source_requested_item} has been denied. You can view your request from the relevant request page to get more information.</p>"
                  ) #to, subject, message
                  @approval.approval_source.approval_denied
                end

                render status: 200, json: { message: "success" }
              else
                render status: 500, :json => { message: "The approval could not be completed." }
              end

            elsif @your_approval.approval.approval_approvers.where("approval_type_id > 3").count >= 1 && @approval.single_consent
              # re-fetch the approval
              @approval = @your_approval.approval

              # it only takes one person to approve this approval
              if @approval.approval_approvers.where("approval_type_id = 4").count >= 1
                @approval.approved = true
              elsif @approval.approval_approvers.where("approval_type_id = 5").count == @approval.approval_approvers.count
                @approval.denied = true
              else
                raise 'Approval out of range (2)'
              end
              if @approval.approved == true || @approval.denied == true
                if @approval.save
                  # if the approval saves then run the completion function
                  if @approval.approved && !@approval.denied
                    # TODO: Data drive this more!!
                    if @approval.approval_workflow == 1 # standard workflow
                      # push notification
                      send_push_notification @approval.approval_source.user.id, "Approval ##{@approval.id} #{@approval.approval_kind.title} Approved"

                      # email the user here
                      send_email(@approval.approval_source.user.email, "#{@approval.approval_kind.title} Approved",
                      "<p>Hello #{@approval.approval_source.user.username}!</p><p>Your #{@approval.approval_kind.title} for #{@approval.approval_source_requested_item} has been approved.</p>"
                      ) #to, subject, message
                      @approval.approval_source.approval_completion
                    elsif @approval.approval_workflow == 2 # applicant workflow
                      # email exec group
                      subject = 'Application approvals completed'
                      message = "#{subject} for #{@approval.approval_source.application.character.full_name}. This application can be advanced to the CEO Review stage once all other previous stages are completed."
                      email_groups([2], subject, message)
                    elsif @approval.approval_workflow == 3 # do nothing workflow
                      # do nothing
                    end
                  else
                    # push notification
                    send_push_notification @approval.approval_source.user.id, "Approval ##{@approval.id} #{@approval.approval_kind.title} Denied"

                    # email the user that the request was denied
                    send_email(@approval.approval_source.user.email, "#{@approval.approval_kind.title} Denied",
                    "<p>Hello #{@approval.approval_source.user.username}!</p><p>Your #{@approval.approval_kind.title} for #{@approval.approval_source_requested_item} has been denied. You can view your request from the relevant request page to get more information.</p>"
                    ) #to, subject, message
                    @approval.approval_source.approval_denied
                  end

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

  # GET api/approval/types
  def approval_types
    render status: 200, json: ApprovalType.all
  end
end
