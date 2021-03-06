class EventsController < ApplicationController
  before_action :require_user
  before_action :require_member
  before_action only: [:new, :create, :edit, :update, :certify_event_attendence, :certify_event_attendence_post, :event_briefing, :event_briefing_patch, :event_debriefing, :event_debriefing_patch, :add_award, :remove_award, :list_expired] do |a|
    a.require_one_role([18,19])
  end
  before_action only: [:certify_event_attendence, :certify_event_attendence_post] do |a|
    a.require_one_role([19])
  end

  # bot only
  before_action only: [:set_auto_attendance] do |a|
    a.require_one_role([-1])
  end

  # GET api/events
  def list
    render status: 200,
    json: Event.where('end_date >= ? AND archived = ?', Time.now, false).order('start_date asc').as_json(include: { event_type: {}, briefing:{ include: { starting_system: {}, ending_system: {}, operational_leader: { methods: [:full_name] }, escort_leader: { methods: [:full_name] }, communications_designee: { methods: [:full_name] }, reporting_designee: { methods: [:full_name] } }}, debriefing: {}, awards: { methods: [:image_url]}, attendences: { include: { character: { methods: [:full_name] }, attendence_type: { } }} }, methods: [:start_date_ms, :end_date_ms, :is_expired])
  end

  # GET api/events/next
  def list_next
    render status: 200,
    json: Event.where('end_date >= ? AND archived = ?', Time.now, false).order('start_date asc').first.as_json(include: { event_type: {}, briefing:{ include: { starting_system: {}, ending_system: {}, operational_leader: { methods: [:full_name] }, escort_leader: { methods: [:full_name] }, communications_designee: { methods: [:full_name] }, reporting_designee: { methods: [:full_name] } }}, debriefing: {}, awards: { methods: [:image_url]}, attendences: { include: { character: { methods: [:full_name] }, attendence_type: { } }} }, methods: [:start_date_ms, :end_date_ms, :is_expired])
  end

  # GET api/events/expired
  # GET api/events/expired/:count
  def list_expired
    if params[:count] && params[:count].to_i
      render status: 200,
      json: Event.where('end_date < ? AND archived = ?', Time.now, false).order('start_date desc').limit(params[:count].to_i).as_json(include: { event_type: {}, briefing:{ include: { starting_system: {}, ending_system: {}, operational_leader: { methods: [:full_name] }, escort_leader: { methods: [:full_name] }, communications_designee: { methods: [:full_name] }, reporting_designee: { methods: [:full_name] } }}, debriefing: {}, awards: { methods: [:image_url]}, attendences: { include: { character: { methods: [:full_name] }, attendence_type: { } }} }, methods: [:start_date_ms, :end_date_ms, :is_expired])
    else
      render status: 200,
      json: Event.where('end_date < ? AND archived = ?', Time.now, false).order('start_date desc').as_json(include: { event_type: {}, briefing:{ include: { starting_system: {}, ending_system: {}, operational_leader: { methods: [:full_name] }, escort_leader: { methods: [:full_name] }, communications_designee: { methods: [:full_name] }, reporting_designee: { methods: [:full_name] } }}, debriefing: {}, awards: { methods: [:image_url]}, attendences: { include: { character: { methods: [:full_name] }, attendence_type: { } }} }, methods: [:start_date_ms, :end_date_ms, :is_expired])
    end
  end

  # GET api/events/:event_id
  def show
    @event = Event.find_by_id(params[:event_id].to_i)
    if @event && !@event.archived
      render status: 200, json: @event.as_json(include: { event_type: {}, briefing:{ include: { starting_system: {}, ending_system: {}, operational_leader: { methods: [:full_name] }, escort_leader: { methods: [:full_name] }, communications_designee: { methods: [:full_name] }, reporting_designee: { methods: [:full_name] } }}, debriefing: {}, awards: { methods: [:image_url]}, attendences: { include: { character: { methods: [:full_name] }, attendence_type: { } }} }, methods: [:start_date_ms, :end_date_ms, :is_expired])
    else
      render status: 404, json: { message: 'Event not found. It may have been removed.' }
    end
  end

  # GET api/events/types
  def get_types
    render status: 200, json: EventType.all
  end

  # GET api/events/attendence-types
  def get_attendence_types
    render status: 200, json: AttendenceType.all
  end

  # POST api/events
  def create
    @event = Event.new(event_params)
    # @event.briefing = EventBriefing.new
    # @event.debriefing = EventDebriefing.new

    @event.start_date = Time.at( params[:event][:start_date_ms] / 1000.0)
    @event.end_date = Time.at( params[:event][:end_date_ms] / 1000.0)

    if @event.save
      # emit event
      EventStreamWorker.perform_async('event-publish', @event)
      
      render status: 200, json: @event
    else
      render status: 500, json: { message: "Event could not be created because: #{@event.errors.full_messages.to_sentence}" }
    end
  end

  # PATCH api/events
  def update
    # Time.at( 1394648309130 / 1000.0 )
    # :name, :description, :start_date, :end_date, :weekly_reccurance, :event_type_id, :show_on_dashboard
    @event = Event.find_by id: params[:event][:id]
    if (@event != nil || !@event.submitted_for_certification) && !@event.archived
      @event.name = params[:event][:name]
      @event.description = params[:event][:description]
      @event.start_date = Time.at(params[:event][:start_date_ms] / 1000.0)
      @event.end_date = Time.at(params[:event][:end_date_ms] / 1000.0)
      @event.weekly_recurrence = params[:event][:weekly_recurrence]
      @event.monthly_recurrence = params[:event][:monthly_recurrence]
      @event.event_type_id = params[:event][:event_type_id]
      @event.show_on_dashboard = params[:event][:show_on_dashboard]
      if @event.save
        render status: 200, json: @event
      else
        render status: 500, json: { message: "Event could not be updated because: #{@event.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Event not found.' }
    end
  end

  # POST api/events/publish
  # Body should include event_id: number
  def publish
    @event = Event.find_by_id(params[:event_id].to_i)
    if @event != nil && !@event.archived
      if !@event.published
        @event.published = true
        @event.published_date = Time.now
        if @event.save
          # send push notifications
          # send_push_notification_to_members("New Event Posted - #{@event.name}")

          # email members about new even posting
          email_members("New Event Posted - #{@event.name}",
          "<p>A new #{@event.event_type.title.downcase} event has been posted on the BendroCorp Dashboard called <b>#{@event.name}</b> with the following description:</p><p>#{@event.description}</p>If you would like more information on this event please visit the events page on the BendroCorp Dashboard.")

          # # send push notifications
          # send_push_notification_to_members("Full event details for #{@event.name} have been published!")

          # emit event
          EventStreamWorker.perform_async('event-publish', @event)

          render status: 200, json: @event
        else
          render status: 500, json: { message: "Error: Event could not be published...check the data you entered." }
        end
      else
        render status: 403, json: { message: "This event has already been published you can not publish an event which has already been published." }
      end
    else
      render status: 404, json: { message: "Event not found." }
    end
  end

  # POST api/events/award
  # Body should contain event_id, award_id
  def event_award
    @event_award = EventAward.where('award_id = ? AND event_id = ?', params[:award_id].to_i, params[:event_id].to_i)
    if @event_award != nil
      if @event_award.destroy_all
        render status: 200, json: { message: 'Event award removed.' }
      else
        render status: 500, json: { message: 'Error Occured. Event award could not be removed.' }
      end
    else
      # render status: 404, json: { message: 'Event award not found.' }
      if @event != nil && !@event.archived
        @award = Award.find_by_id(params[:event_id].to_i)
        if @award != nil
          @event.awards << @award
          if @event.save
            render status: 200, json: @award
          else
            render status: 500, json: { message: 'Error Occured. Award not added to event' }
          end
        else
          render status: 404, json: { message: "Award not found." }
        end
      else
        render status: 404, json: { message: "Event not found." }
      end
    end
  end

  # PATCH api/events/briefing
  # Body should contain event_id and briefing object
  def event_briefing_update
    @briefing = EventBriefing.find_by_id(params[:briefing][:id])
    if !@briefing.event.published && true?(params[:briefing][:published])
      @briefing.published_when = Time.now
    end
    if @briefing != nil && !@briefing.event.submitted_for_certification
      if @briefing.update(event_briefing_params)
        render status: 200, json: @briefing
      else
        render status: 500, json: { message: 'Error Occured. Could not update event briefing.' }
      end
    else
      # flash[:info] = 'Event not found.'
      # redirect_to :action => 'index'
      render status: 404, json: { message: "Event not found. It may have been removed!" }
    end
  end

  # PATCH api/events/debriefing
  # Body should contain event_id and debriefing object
  def event_debriefing_update
    @debriefing = EventDebriefing.find_by_id(params[:event_id])
    if @debriefing != nil && !@debriefing.event.submitted_for_certification
      if @debriefing.event.is_expired
        if @debriefing.update(event_debriefing_params)
          render status: 200, json: @debriefing
        else
          render status: 500, json: { message: 'Error Occured. Could not update event briefing.' }
        end
      else
        render status: 403, json: { message: "You cannot edit an events debriefing until after the event has expired." }
      end
    else
      render status: 404, json: { message: 'Event not found.' }
    end
  end

  # POST api/events/attend
  # Allows an individual user to set their attendence
  # Body should contain event_id and attendence_type_id (1=Attending,2=Not Attending,3=No Response)
  def set_attendence
    @event = Event.find_by id: params[:event_id].to_i
    # Look if the event exists and if it has already been submitted_for_certification
    if @event != nil && !@event.submitted_for_certification
      if !@event.is_expired
        # Look and see if the attendence already exists if so we are just going to update it
        @attendence = Attendence.where('user_id = ? AND event_id = ?', current_user.id, params[:event_id]).first
        if @attendence != nil
          @attendence.attendence_type_id = params[:attendence_type_id].to_i

          if @attendence.save
            render status: 200, json: @attendence.as_json(include: { character: { methods: [:full_name] }, attendence_type: { } })
          else
            render status: 500, json: { message: 'Error: Attendence could not be updated.' }
          end
        else # if the attendence does not exist then we are going to create it
          @attendence = Attendence.new(event_id: params[:event_id].to_i,
                                      user_id: current_user.id,
                                      character_id: current_user.main_character.id,
                                      attendence_type_id: params[:attendence_type_id].to_i)
          if @attendence.save
            render status: 201, json: @attendence.as_json(include: { character: { methods: [:full_name] }, attendence_type: { } })
          else
            render status: 500, json: { message: 'Error: Attendence could not be updated.' }
          end
        end
      else
        render status: 403, json: { message: 'Event expired. Attendance cannot be changed!' }
      end
    else
      render status: 404, json: { message: 'Event not found.' }
    end
  end

  # POST api/events/attend/auto
  # :event_id, :discord_user_ids [string]
  def set_auto_attendance
    @event = Event.find_by_id(params[:event_id].to_i)
    if @event
      current_auto_attenders = EventAutoAttendance.where("event_id = ?", params[:event_id]).map(&:user_id) if params[:discord_user_ids].count > 0
      # iterate through each user
      params[:discord_user_ids].each do |discord_id|
        # check to see if there already is a record
        discord_identity = DiscordIdentity.find_by discord_id: discord_id
        if discord_identity
          if !current_auto_attenders.include? discord_identity.user_id
            eaa = EventAutoAttendance.new(event_id: params[:event_id], user_id: discord_identity.user_id)
            if !eaa.save
              raise "Could not save auto-attendance because: #{eaa.errors.full_messages.to_sentence}"
            end
          end
        end
      end

      render status: 200, json: { message: 'Auto attendance completed!' }
    else
      render status: 404, json: { message: 'Event not found.' }
    end
  end

  # GET api/events/:event_id/certify
  # This creates negative attendence objects for all members who did not already create an attendence for the event
  # Body should contain event_id
  def certify_event_attendence
    @event = Event.find_by_id(params[:event_id].to_i)
    if @event != nil && !@event.submitted_for_certification
      if @event.is_expired

        # the auto attendance array
        auto_attendance = []

        # populate auto attendance array and mark auto attendances as processed
        EventAutoAttendance.where(event_id: params[:event_id].to_i, processed: false).each do |auto|  # .map(&:user_id)
          # add the id to the array
          auto_attendance << auto.user_id

          # processed
          auto.processed = true
          auto.save
        end

        # check to see if any records have been processed if this is the case set the boolean
        processing_done = true if EventAutoAttendance.where(event_id: params[:event_id].to_i, processed: true).count > 0

        # array of all current attendees
        attender_ids = []

        # loop through the current attendances and..
        # 1. Get their user.id into the attender_ids array
        # 2. Adjust the user's attendance type/status based on the auto attendance
        Attendence.where(event_id: params[:event_id]).each do |attendance| # .map(&:user_id)
          # add the list to the attender_ids
          attender_ids << attendance.user_id

          # set the attendance for the current attendees based on the auto attendance if they have a valid discord_identity
          if attendance.user.discord_identity && !processing_done
            # are the in the attendance list?
            if auto_attendance.include? attendance.user_id
              attendance.attendence_type_id = 1 # attending
            else
              attendance.attendence_type_id = 2 # not attending
            end

            # save the modified attendance record
            attendance.save
          end
        end

        # get all of the users not in the `attendance` table id list
        users = Role.find_by_id(0).role_full_users.filter { |user| !attender_ids.include? user.id }

        # interate through the list and assign negative attendance unless they are present in the auto attendance table
        users.each do |user|
          # if the user exists in the auto attendance for the event the mark as attending
          # this is in case they didn't say either way but Discord knows they showed up
          if auto_attendance.include? user.id
            attendence_type_id = 1
          else
            attendence_type_id = 2
          end

          # create the new attendance
          attendence = Attendence.new(event_id: params[:event_id].to_i,
                                       user_id: user.id,
                                       character_id: user.main_character.id,
                                       attendence_type_id: attendence_type_id)
          attendence.save
        end

        # then we reload the event to get the attendences
        @event = Event.find_by_id(params[:event_id].to_i)

        # return attendances
        render status: 200, json: @event.attendences.as_json(include: { character: { methods: [:full_name] }})
      else
        render status: 403, json: { message: 'Event end time has not expired. You can not certify an event until after it has concluded.' }
      end
    else
      render status: 404, json: { message: 'Event not found. It may have been removed.' }
    end
  end

  # POST api/events/:event_id/certify
  # This will initiate the creation of the ECR and close the event
  # Body should contain event_id
  def certify_event_attendence_post
    #create approval if create approval selected
    @event = Event.find_by_id(params[:event_id])
    if @event != nil && !@event.submitted_for_certification && !@event.certified && @event.event_certification_request == nil
      # check to make sure debriefing is submitted
      # TODO: ^^ This
      # update the event first
      if @event.update(event_certify_params)
        #create certification request
        ecr = EventCertificationRequest.new(event_id: @event.id)
        #create approval
        ecr.approval_id = new_approval(6)
        ecr.user_id = current_user.id
        if ecr.save
          @event.submitted_for_certification = true
          @event.event_certification_request_id = ecr.id
          if @event.save
            render status: 200, json: @event
          else
            render status: 500, json: { message: 'Error Occured. Event could not be submitted for certification' }
          end
        else
          @event.submitted_for_certification = false
          if @event.save
            render status: 500, json: { message: 'ERROR: ECR could not be saved. Event reverted so certification could be made.' }
          else
            render status: 500, json: { message: 'ERROR: ECR could not be saved and the event could not be updated. Data wise this is probably really messed up you will need to contact Rindzer.' }
          end
        end
      else
        render status: 500, json: { message: "An error occured and the event could not be updated." }
      end
    else
      render status: 404, json: { message: 'Either this event was not found or has already been submitted for certification.' }
    end
  end

  # DELETE api/events/:event_id/
  def archive_event
    @event = Event.find_by_id(params[:event_id])
    if @event != nil && !@event.submitted_for_certification && !@event.certified && @event.event_certification_request == nil
      @event.archived = true
      if @event.save
        render status: 200, json: { message: 'Event archived!' }
      else
        render status: 500, json: { message: "Event could not be archived because: #{@event.errors.full_messages.to_sentence}" }
      end
    else
      render status: 404, json: { message: 'Event was not found or has been submitted for certification.' }
    end
  end

  private
  def event_params
    params.require(:event).permit(:name, :description, :weekly_recurrence, :monthly_recurrence, :event_type_id, :show_on_dashboard)
  end

  def event_update_params
    params.require(:event).permit(:name, :description, :weekly_recurrence, :monthly_recurrence, :event_type_id, :show_on_dashboard)
  end

  private
  def event_certify_params
    params.require(:event).permit(:id, attendences_attributes:[:id, :attendence_type_id], debriefing_attributes:[:id, :text])
  end

  private
  def event_debriefing_params
    params.require(:debriefing).permit(:text, :published)
  end

  private
  def event_briefing_params
    params.require(:briefing).permit(:operational_leader_id,:reporting_designee_id,:communications_designee_id,:escort_leader_id,:objective,:notes,:starting_system_id,:ending_system_id,:published)
  end
end
