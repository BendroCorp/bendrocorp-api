class ApprovalsController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action only: [:add_approver, :not_needed_approver] do |a|
    a.require_one_role([9]) # ceo
  end

  # POST api/approvals
  # 
  def create_approval
    # approval_kind_id, owner_id = 0, approval_group = 0, approval_id_list = [], approvals_required = true
    if params[:new_approval] && params[:new_approval][:approval_kind_id]
      approval_id = new_approval(
        params[:new_approval][:approval_kind_id],
        params[:new_approval][:owner_id],
        params[:new_approval][:approval_group],
        params[:new_approval][:approval_id_list],
        params[:new_approval][:approvals_required]
      )
      render status: 200, json: { approval_id: approval_id }
    else
      render status: 400, json: { message: 'Request not properly formed. See documentation.' }
    end
  end

  # get api/approvals/:approval_id/:approval_type
  def approval_request
    #@your_approval = ApprovalApprover.find_by id: params[:approval_id].to_i
    @your_approval = ApprovalApprover.where("approval_id = ? AND user_id = ?", params[:approval_id].to_i, current_user.id).first #find_by id: params[:approval_id].to_i
    if !@your_approval.nil?
      @approval = @your_approval.approval
      if @your_approval.user.id == current_user.id #approvals can only be made by the from whom they are requested
        if @your_approval.approval_type_id < 4 && (params[:approval_type].to_i == 4 || params[:approval_type].to_i == 5)
          @your_approval.approval_type_id = params[:approval_type].to_i

          if @your_approval.save!
            # check and see if we should update the approval status
            # first check to see if all of the approver have weighed in
            # full consent meta workflow
            check_for_approval_completion @your_approval.approval
          else
            # failure from the initial approver approval status change
            render status: 500, json: { message: 'Approval could not be saved.' }
          end
        else
          puts "Approval type not valid - Current Type Id: #{@your_approval.approval_type_id} - Incoming Type Id #{params[:approval_type]}"
          render status: 500, json: { message: 'Selected approval type not valid' }
        end
      else
        render status: 403, json: { message: 'You are not authorized to change the status of this approval.' }
      end
    else
      render status: 404, json: { message: 'Approval does not exist...' }
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

  # POST api/approvals/approver
  # :approval_id, :user_id
  def add_approver
    ApprovalApprover.transaction do
      approval_approver = ApprovalApprover.new(approval_id: params[:approval_id].to_i, user_id: params[:user_id].to_i, approval_type_id: 1)
      if approval_approver.save
        render status: 200, json: { message: 'Approver added.' }
      else
        render status: 500, json: { message: "Approver could not be added because: #{approval_approver.errors.full_messages.to_sentence}" }
      end
    end
  end

  # DELETE api/approvals/approver/:approver_id
  def not_needed_approver
    ApprovalApprover.transaction do
      approval_approver = ApprovalApprover.find_by_id(params[:approver_id])
      puts approval_approver.inspect
      approval = Approval.find_by_id(approval_approver.approval_id)
      # make sure we found the object and that 
      if approval_approver && !(approval.denied || approval.approved)
        approval_approver.approval_type_id = 6 # not needed status
        if approval_approver.save
          # notify the approver
          send_push_notification(
            approval_approver.user_id,
            "Your approval has been marked 'Not Needed' for #{approval_approver.approval.id} by #{current_user.main_character.full_name}",
            data: { approver_id: approval_approver.id },
            apns_category: 'APPROVAL_CHANGE'
          )

          check_for_approval_completion approval, true
          render status: 200, json: { message: 'Approver status changed to no longer required.' }
        else
          render status: 500, json: { message: "Approver status could not be changed because: #{approval_approver.errors.full_messages.to_sentence}" }
        end
      else
        render status: 404, json: { message: 'Approval approver not found or the approval has already been completed!' }
      end
    end
  end

  # post api/approvals/override/
  # This override endpoint is meant for broad use to clear the queue. Should be used with great care!
  def approval_override
    Approval.transaction do
      if current_user.isinrole(9) # only the CEO may use this endpoint
        if current_user.db_user.two_factor_valid params[:code].to_i # must use two factor to use this method
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
                approver_push_text = "Approval ##{@approval.id} #{@approval.approval_kind.title} has been approved via CEO override and your feedback is no longer needed."
                approver_email_text = "<p>#{approver.user.main_character.first_name},</p><p>Approval ##{@approval.id} #{@approval.approval_kind.title} to which you are an approver has been approved via override by the CEO and your feedback is no longer needed.</p><p>#{@approval.approval_approvers.map { |approver_inner| "#{approver_inner.user.main_character.full_name}: #{approver_inner.approval_type.title}" }.join('<br>')}</p>"

                # send_push_notification approver.user.id, approver_push_text
                send_push_notification(
                  approver.user.id,
                  approver_push_text,
                  apns_category: 'APPROVAL_CHANGE',
                  data: { approver_id: approver.id } # approver id not approval id? Oversight?
                )
                # send email
                send_email(approver.user.email, 'Approval Overriden', approver_email_text)
              end

              # if there is a report attached deal with it as well
              if approval.report
                approval.report.draft = true if approval.denied
                approval.report.approved = true if approval.approved
                approval.save
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
  end

  # post 'api/approvals/override/:approval_id'
  # Body contains :code, approval_type_id
  def approval_override_specific
    if current_user.isinrole(9) # only the CEO may use this endpoint
      if current_user.db_user.two_factor_valid params[:code].to_i # must use two factor to use this method
        @approval = Approval.where(denied: false, approved: false, id: params[:approval_id].to_i).first
        if @approval
          @approvers = @approval.approval_approvers.where('approval_type_id < 4')
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
              approver_push_text = "Approval ##{@approval.id} #{@approval.approval_kind.title} has been completed via CEO override and your feedback is no longer needed."
              approver_email_text = "<p>#{approver.user.main_character.first_name},</p><p>Approval ##{@approval.id} #{@approval.approval_kind.title} to which you are an approver has been completed via override by the CEO and your feedback is no longer needed.</p><p>#{@approval.approval_approvers.map { |approver_inner| "#{approver_inner.user.main_character.full_name}: #{approver_inner.approval_type.title}" }.join('<br>')}</p>"

              # send_push_notification
              send_push_notification(
                approver.user.id,
                approver_push_text,
                apns_category: 'APPROVAL_CHANGE',
                data: { approver_id: approver.id } # approver id not approval id? Oversight?
              )
              # send email
              send_email(approver.user.email, 'Approval Overriden', approver_email_text)
            end

            # if there is a report attached deal with it as well
            if approval.report
              approval.report.draft = true if approval.denied
              approval.report.approved = true if approval.approved
              approval.save
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
  def check_for_approval_completion approval, skipRender = false
    if approval.approval_approvers.where('approval_type_id > 3').count >= 1 && approval.full_consent

      approversCount = approval.approval_approvers.count
      approved = approval.approval_approvers.where(approval_type_id: 4).count
      denied = approval.approval_approvers.where(approval_type_id: 5).count
      not_needed = approval.approval_approvers.where(approval_type_id: 6).count

      if denied.positive? # for full consent if any one denies then the approval has failed. So no need to keep going. ;)
        approval.denied = true
        # Change the status of unsubmitted approvals to not needed
        approval.approval_approvers.where('approval_type_id < 4').to_a.each do |approver|
          approver.approval_type_id = 6
          approver.save!
        end
      elsif approved + not_needed >= approversCount
        approval.approved = true
      elsif approved + not_needed < approversCount
        # helpful note just to mark out this condition :)
        # do nothing because we dont have full consent yet
      else
        raise 'Approval consent out of range!'
      end

      if approval.save
        # #
        if approval.approved && !approval.denied
          SiteLog.create(module: 'Approvals', submodule: 'Approval Approved', message: "Approval ##{approval.id} has been approved!", site_log_type_id: 2)
        elsif !approval.approved && approval.denied
          SiteLog.create(module: 'Approvals', submodule: 'Approval Denied', message: "Approval ##{approval.id} has been denied!", site_log_type_id: 2)
        end

        # if there is a report attached deal with it as well
        if approval.report
          approval.report.draft = true if approval.denied
          approval.report.approved = true if approval.approved
          approval.save
        end

        # run final workflow
        run_approval_workflow approval

        if !skipRender
          render status: 200, json: { message: 'Approval status changed.' }
        end
      else
        if !skipRender
          render status: 500, json: { message: 'The approval could not be completed.' }
        end
      end

    # single consent meta workflow
    elsif approval.approval_approvers.where('approval_type_id > 3').count >= 1 && approval.single_consent

      # it only takes one person to approve this approval
      if approval.approval_approvers.where('approval_type_id = 4').count >= 1
        approval.approved = true
        # Change the status of unsubmitted approvals to not needed
        approval.approval_approvers.where('approval_type_id < 4').to_a.each do |approver|
          approver.approval_type_id = 6
          approver.save!
        end

      elsif approval.approval_approvers.where('approval_type_id = 5').count == approval.approval_approvers.count
        approval.denied = true
      else
        raise 'Approval out of range (2)'
      end
      # NOTE: This if statement does not totally make sense
      if approval.approved == true || approval.denied == true
        if approval.save
          # if the approval saves then run the completion function
          if approval.approved && !approval.denied
            SiteLog.create(module: 'Approvals', submodule: 'Approval Approved', message: "Approval ##{approval.id} has been approved!", site_log_type_id: 2)
          elsif !approval.approved && approval.denied
            SiteLog.create(module: 'Approvals', submodule: 'Approval Denied', message: "Approval ##{approval.id} has been denied!", site_log_type_id: 2)
          end

          # if there is a report attached deal with it as well
          if approval.report
            approval.report.draft = true if approval.denied
            approval.report.approved = true if approval.approved
            approval.save
          end

          # run final workflows
          run_approval_workflow approval

          if !skipRender
            render status: 200, json: { message: 'Success' }
          end
        else
          if !skipRender
            render status: 500, json: { message: 'The approval could not be completed.' }
          end
        end
      else
        if !skipRender
          render status: 200, json: { message: 'Approval updated.' }
        end
      end
    else
      if !skipRender
        render status: 200, json: { message: 'Approval updated.' }
      end
    end
  end

  def run_approval_workflow approval
    # run the normal approval workflow
    if approval.approved == true && !approval.denied == true
      # TODO: Data drive this more!!
      if approval.approval_workflow == 1 || approval.approval_workflow == 4 # standard workflow
        # push notification to the approval creator
        send_push_notification approval.approval_source.user.id, "Approval ##{approval.id} #{approval.approval_kind.title} Approved"

        # notify the approvers of the status of the approval
        approval.approval_approvers.to_a.each do |approver|
          approver_push_text = "Approval ##{approval.id} #{approval.approval_kind.title} has been approved!"
          approver_email_text = "<p>#{approver.user.main_character.first_name},</p><p>Approval ##{approval.id} #{approval.approval_kind.title} to which you are an approver has been approved.</p><p>#{approval.approval_approvers.map { |approver_inner| "#{approver_inner.user.main_character.full_name}: #{approver_inner.approval_type.title}" }.join('<br>')}</p>"

          # send_push_notification approver.user.id, approver_push_text
          send_push_notification(
            approver.user.id,
            approver_push_text,
            apns_category: 'APPROVAL_CHANGE',
            data: { approver_id: approver.id } # approver id not approval id? Oversight?
          )
          send_email approver.user.email, "Approval Approved", approver_email_text
        end

        # email the user here
        send_email(approval.approval_source.user.email, "#{approval.approval_kind.title} Approved",
        "<p>Hello #{approval.approval_source.user.username}!</p><p>Your #{approval.approval_kind.title} for #{approval.approval_source_requested_item} has been approved.</p>"
        ) #to, subject, message

        # run the completion function on the request
        approval.approval_source.approval_completion
      elsif approval.approval_workflow == 2 # applicant workflow
        # email exec group
        subject = 'Application approvals completed'
        message = "#{subject} for #{approval.approval_source.application.character.full_name}. This application can be advanced to the CEO Review stage once all other previous stages are completed."
        email_groups([2], subject, message)
      elsif approval.approval_workflow == 3 # do nothing workflow
        # do nothing
      end
    elsif !approval.approved == true && approval.denied == true # if the approval is denied and not approved
      # push notification to the approval creator
      send_push_notification approval.approval_source.user.id, "Approval ##{approval.id} #{approval.approval_kind.title} Denied"

      # notify the approvers of the denial
      # notify the approvers of the status of the approval
      approval.approval_approvers.to_a.each do |approver|
        approver_push_text = "Approval ##{approval.id} #{approval.approval_kind.title} has been denied!"
        approver_email_text = "<p>#{approver.user.main_character.first_name},</p><p>Approval ##{approval.id} #{approval.approval_kind.title} to which you are an approver has been denied.</p><p>#{approval.approval_approvers.map { |approver_inner| "#{approver_inner.user.main_character.full_name}: #{approver_inner.approval_type.title}" }.join('<br>')}</p>"

        send_push_notification approver.user.id, approver_push_text
        send_email approver.user.email, "Approval Denied", approver_email_text
      end

      # email the user that the request was denied
      send_email(approval.approval_source.user.email, "#{approval.approval_kind.title} Denied",
      "<p>Hello #{approval.approval_source.user.username}!</p><p>Your #{approval.approval_kind.title} for #{approval.approval_source_requested_item} has been denied. You can view your request from the relevant request page to get more information.</p>"
      ) #to, subject, message

      # run the denial function on the request
      approval.approval_source.approval_denied
    else
      puts 'Approval workflow not run. No action required.'
    end
  end
end
