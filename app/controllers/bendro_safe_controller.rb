class BendroSafeController < ApplicationController
  before_action :require_user

  # POST api/safe/search
  # params[:rsi_handle]
  # Used by BendroSAFE
  def profile_search
    rsi_data = {}
    intel_data = {}
    offender_data = {}
    override_data = {}
    summary_level = ''
    final_message = ''

    # guard to make sure that the RSI handle is present
    if params[:rsi_handle].nil?
      render status: :unprocessable_entity, json: { message: 'rsi_handle not supplied' }
      return
    end

    # RSI scrape
    begin
      @page = HTTParty.get("https://robertsspaceindustries.com/citizens/#{params[:rsi_handle].to_s.downcase}", timeout: 15)

      if @page.code != 200
        rsi_data = { rsi_code: @page.code, threat: false, data: nil, message: 'Data not found' } if @page.code == 404
        rsi_data = { rsi_code: @page.code, threat: false, data: nil, message: 'Could not retrieve Spectrum data' } if @page.code != 404
      else
        handle_value = params[:rsi_handle].to_s
        threat_assessment = false

        scrape_results = RSIHandleScraper.scrape(rsi_handle: handle_value)
        rsi_avatar = "https://robertsspaceindustries.com#{scrape_results[:toon_pic]}"

        # we care about if they are in an org
        # and especially if that org is redacted
        is_redacted = true if !scrape_results[:is_redacted].nil?
        is_redacted ||= false

        if !is_redacted
          org_title = scrape_results[:org_title]
          org_link = "https://robertsspaceindustries.com/orgs/#{scrape_results[:org_spectrum_id]}"
          focus_one = scrape_results[:org_focus][0] if scrape_results[:org_focus] && scrape_results[:org_focus][0]
          focus_two = scrape_results[:org_focus][1] if scrape_results[:org_focus] && scrape_results[:org_focus][1]
          org_logo = "https://robertsspaceindustries.com#{scrape_results[:org_logo]}"
        else 
          org_logo = "https://robertsspaceindustries.com#{scrape_results[:org_logo]}"
        end

        is_in_pirate_group = !org_title.nil? && (focus_one.downcase == 'piracy' || focus_two.downcase == 'piracy') ? true : false
        threat_assessment = is_in_pirate_group || is_redacted ? true : false
        safe_level = is_in_pirate_group || is_redacted ? 'danger' : 'neutral'

        final_message = 'Spectrum handle search did not discover concerning data.'
        final_message = "#{handle_value} has redacted their primary organization. This is a red flag in most instances. Exercise caution." if is_redacted
        final_message = "#{handle_value} should be considered dangerous and caution should be exercised given their affiliation with pirate organizations." if is_in_pirate_group 

        # are they actually in an org
        if scrape_results[:org_title]
          rsi_data = {
            rsi_code: @page.code,
            handle: handle_value,
            joined_date: scrape_results[:joined_date],
            rsi_avatar: rsi_avatar,
            org_title: org_title,
            org_link: org_link,
            org_redacted: is_redacted,
            focus_one: focus_one,
            focus_two: focus_two,
            org_logo: org_logo,
            threat_assessment: threat_assessment,
            threat_message: final_message,
            safe_level: safe_level,
            is_in_pirate_group: is_in_pirate_group
          }
        else
          rsi_data = {
            rsi_code: @page.code,
            handle: handle_value,
            joined_date: scrape_results[:joined_date],
            rsi_avatar: rsi_avatar,
            org_title: nil,
            org_redacted: is_redacted,
            focus_one: nil,
            focus_two: nil,
            org_logo: nil,
            threat_assessment: threat_assessment,
            threat_message: final_message,
            safe_level: safe_level,
            is_in_pirate_group: is_in_pirate_group
          }
        end
      end
    rescue StandardError => e
      error_trade = e.backtrace.join("\n")
      rsi_data = { rsi_code: 500, threat: false, data: nil, message: 'Could not retrieve Spectrum data' }
    end

    # TODO: Merge with offender reports and intel system
    # Get intel system cases
    intelligence_case = IntelligenceCase.where('archived = false AND rsi_handle = ?', params[:rsi_handle]).first
    if intelligence_case
      # if not cfa4b341-dc8d-498d-b68f-3db2482ce66c <-- threat level - no threat
      # !current_user.db_user.classification_check(intelligence_case.classification_level
      # if public ie show_in_safe

      if intelligence_case.show_in_safe && current_user.db_user.classification_check(intelligence_case.classification_level)
        threat_assessment = intelligence_case.threat_level_id != 'cfa4b341-dc8d-498d-b68f-3db2482ce66c'

        threat_message = ''
        safe_level = ''
        if threat_assessment
          threat_message = 'BenSec has an existing case which indicates that this handle may be a threat to life or property. Exercise caution.'
          safe_level = 'danger'
        else
          threat_message = 'BenSec has an existing case which indicates that this handle is not a threat.'
          safe_level = 'green'
        end

        intel_data = {
          threat_assessment: threat_assessment,
          threat_message: threat_message,
          safe_level: safe_level,
          case_exists: true,
          case_id: intelligence_case.id
        }
      else
        intel_data = {
          threat_assessment: false,
          threat_message: 'No current BenSec data exists or is available for your classification level for this handle.',
          safe_level: 'neutral',
          case_exists: true,
          case_id: intelligence_case.id
        }
      end
    else
      intel_data = {
        case_exists: false,
        threat_assessment: false,
        threat_message: 'No current BenSec data exists or is available for your classification level for this handle.',
        safe_level: 'neutral',
        case_id: nil
      }
    end

    # offender cases
    offender = OffenderReportOffender.find_by(offender_handle: params[:rsi_handle].to_s.downcase)

    if offender && offender.rating_id > 1
      offender_data = {
        threat_assessment: true,
        threat_message: 'This handle has outstanding incident reports against it. Extreme caution should be used when interacting with this individual',
        safe_level: 'danger'
      }
    else
      offender_data = {
        threat_assessment: false,
        threat_message: 'No current incident report data for this handle.',
        safe_level: 'neutral'
      }
    end

    # Final assessment
    if rsi_data[:threat_assessment] || intel_data[:threat_assessment] || offender_data[:threat_assessment]
      summary_level = 'danger'
      final_message = "#{params[:rsi_handle]} should be considered dangerous and caution should be exercised when interacting with them. See individual summaries for more information."
    else
      # set final message info
      summary_level = 'warning'
      final_message = 'No additional information is available for this citizen. As always exercise caution with a stranger.'
    end

    # Add non-threat overrides
    # bendroCorp member
    user_is_bendro_member = Role.find_by_id(0).role_full_users.select do |user|
      user if user.rsi_handle && user.rsi_handle != '' && user.rsi_handle.downcase == params[:rsi_handle].to_s.downcase
    end

    # is bendrocorp
    if user_is_bendro_member.count > 0 || (!rsi_data[:org_title].nil? && rsi_data[:org_title].downcase == 'bendrocorp')
      # set overrides
      override_data = {
        threat_assessment: false,
        threat_message: 'This individual is a member of BendroCorp or an affiliate.',
        safe_level: 'green'
      }

      # set finals
      summary_level = 'green'
      final_message = 'This individual is a member of BendroCorp or an affiliate.'
    else
      # set override data
      override_data = {
        threat_assessment: false,
        threat_message: 'No overrides were made for this handle.',
        safe_level: 'neutral'
      }
    end

    # return the result
    render status: 200, json: {
      search_threat: threat_assessment,
      offender_threat: false,
      intel_threat: false,
      message: final_message,
      summary_level: summary_level,
      rsi_data: rsi_data,
      intel_data: intel_data,
      offender_data: offender_data,
      override_data: override_data
    }
  end
end
