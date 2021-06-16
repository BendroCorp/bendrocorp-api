require 'nokogiri'
require 'httparty'

# Exists to scrape data from the RSI profile pages
module RSIHandleScraper
  class << self
    # make the scrape happen
    def scrape(rsi_handle:)
      # It will be a sad day when CIG does something else with this page
      uri = "https://robertsspaceindustries.com/citizens/#{rsi_handle}"
      page = HTTParty.get(uri, timeout: 15)

      # get and check the page code
      code = page.code
      if page.code == 200

        parse_page = Nokogiri::HTML(page)

        final_hash = {}
        # line break :)
        puts
        puts "RSI Handle Scrape Results"

        # get their info
        toon_raw = parse_page.css('.profile').css('.inner').css('.info').css('.entry').css('.value').map.to_a
        toon_raw.each do |a|
          # 0 - Full Name
          # 1 - Handle
          # 2 - forum title
        end

        final_hash[:joined_date] = parse_page.css('.profile-content > .left-col').css('.inner').css('p.entry').css('.value').map.to_a[0].text

        # get picture
        toon_pic = ""
        thumb_element = parse_page.css('.profile').css('.inner').css('.thumb img')

        if thumb_element
          toon_pic = thumb_element.attr('src')
        end

        final_hash[:toon_name] = toon_raw[0].text if toon_raw[0]
        final_hash[:toon_handle] = toon_raw[1].text if toon_raw[1]
        final_hash[:toon_forum_title] = toon_raw[2].text if toon_raw[2]
        final_hash[:toon_pic] = toon_pic if toon_pic

        #org info
        # 0 - Org Title
        # 1 - Spectrum ID
        # 2 - Member Rank
        org_info_raw = []
        org_info_raw = parse_page.css('.main-org').css('.inner').css('.info').css('.entry').css('.value').map.to_a

        # check for redaction
        redacted = parse_page.css('.main-org').css('.inner').css('.thumb').css('img').attr('src').to_s
        if redacted.include?("redacted")
          final_hash[:is_redacted] = redacted.include?("redacted")
          final_hash[:org_logo] = redacted
        end

        if org_info_raw.count > 0 && /^[a-zA-Z0-9_.-]*$/.match(org_info_raw[1].text)
          #org Rank
          org_rank = parse_page.css('.main-org').css('.inner').css('.info').css('.ranking').css('.active').map.count

          final_hash[:org_rank] = org_rank
          final_hash[:org_title] = org_info_raw[0].text if org_info_raw[0]
          final_hash[:org_spectrum_id] = org_info_raw[1].text if org_info_raw[1]
          final_hash[:org_member_rank] = org_info_raw[2].text if org_info_raw[2]

          # get the org info
          #

          page_org = HTTParty.get("https://robertsspaceindustries.com/orgs/" + org_info_raw[1])

          parse_page_org = Nokogiri::HTML(page_org)

          org_image = parse_page_org.css('#organization').css('.inner').css('.logo img').attr('src')
          final_hash[:org_logo] = org_image

          parse_page_org.css('#organization').css('.inner').css('.logo').css('.count').map do |a|
            final_hash[:org_member_count] = a.text.sub(/ members$/, '').to_i
          end

          parse_page_org.css('#organization').css('.inner').css('.tags').css('li').css('.model').map do |a|
            final_hash[:org_model] = a.text
          end

          parse_page_org.css('#organization').css('.inner').css('.tags').css('li').css('.commitment').map do |a|
            final_hash[:org_commitment] = a.text
          end
  
          parse_page_org.css('#organization').css('.inner').css('.tags').css('li').css('.roleplay').map do |a|
            final_hash[:org_roleplay] = a.text
          end

          final_hash[:org_focus] = []
          parse_page_org.css('#organization').css('.inner').css('.focus').css('li img').map do |a|

            final_hash[:org_focus] << a.attr('alt')

            #final_hash[:org_roleplay] = a.text
          end
        else
          puts "Offender has no org"
        end

        #output hash
        final_hash.each do |key, value|
          puts "#{key} : #{value}"
        end

        # return the final hash object
        final_hash
      else
        puts "Thats not actually an RSI handle..."
      end
    end

    # example
    # if scrape_results
    #   # TODO: Verify the scrape results. This will make sure that if CIG changes anything on the page that everything doesn't explode

    #   # Deal with the org, if they have one
    #   if scrape_results[:org_rank]
    #     # First deal with the org itself
    #     offender_org = OffenderReportOrg.find_by spectrum_id: scrape_results[:org_spectrum_id].downcase
    #     org_exists = offender_org != nil
    #     offender_org = OffenderReportOrg.new unless offender_org # if it doesn't exist then make a new one

    #     # Only populate a new org with the spectrum_id
    #     offender_org.spectrum_id = scrape_results[:org_spectrum_id].downcase unless org_exists

    #     # Do the other org things
    #     offender_org.title = scrape_results[:org_title]
    #     offender_org.member_count = scrape_results[:org_member_count].to_i
    #     offender_org.model = scrape_results[:org_model]
    #     offender_org.commitment = scrape_results[:org_commitment]
    #     offender_org.primary_activity = scrape_results[:org_focus][0] if scrape_results[:org_focus][0]
    #     offender_org.secondary_activity = scrape_results[:org_focus][1] if scrape_results[:org_focus][1]
    #     offender_org.logo = "https://robertsspaceindustries.com#{scrape_results[:org_logo]}"

    #     puts offender_org.inspect

    #     # Save back the offender's org
    #     offender_org.save!

    #     offender.offender_org_rank = scrape_results[:org_rank]
    #     offender.org_title = scrape_results[:org_member_rank]
    #     offender.offender_report_org_id = offender_org.id

    #     # Finally update the offender again
    #     puts offender.inspect
    #     offender.save!
    #   end
    # else
    #   # Need to do something here
    #   # If we get a 404 dont scrape this any more
    #   offender.dont_scrape = true
    #   offender.save!
    # end
  end
end
