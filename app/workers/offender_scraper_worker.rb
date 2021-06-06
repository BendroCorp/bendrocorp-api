require 'sidekiq-scheduler'
require 'nokogiri'
require 'httparty'

class OffenderScraperWorker
  include Sidekiq::Worker

  def perform(*args)
    # Go through all of the offenders
    offenders = OffenderReportOffender.all
    puts "Found #{offenders.count} offenders."
    offenders.each do |offender|
      puts "Processing #{offender.offender_handle}..."
      # we only care about offenders with valid reports
      if offender.offender_reports.count > 0 #&& offender.offender_handle_verified
        puts "Found #{offender.offender_reports.count} valid reports for #{offender.offender_handle}."

        # first deal with the offender and their rating
        # Get the number of each kind of infraction and crunch the offender's individual rating
        collected_infractions = []

        offender.offender_reports.each { |report| collected_infractions << report.infractions }

        # we are going to end up with a bunch of arrays so flatten them out
        collected_infractions.flatten!

        total_infractions_count = collected_infractions.count
        type1_offense_count = (collected_infractions.select { |item| item.violence_rating_id == 1 }).count # annoying
        type2_offense_count = (collected_infractions.select { |item| item.violence_rating_id == 2 }).count # dangerous
        type3_offense_count = (collected_infractions.select { |item| item.violence_rating_id == 3 }).count # lethal

        # three offense levels are currently weighted equally
        percentage = ((((type1_offense_count * 0.33) + (type2_offense_count * 0.66) + (type3_offense_count * 0.99)) / total_infractions_count) * 100).round

        if percentage > 0 && percentage <= 33
          offender.offender_rating_id = 1
        elsif percentage > 33 && percentage < 66
          offender.offender_rating_id = 2
        elsif percentage >= 66 && percentage <= 100
          offender.offender_rating_id = 3
        end
        puts "Offense Counts: 1 - #{type1_offense_count}, 2 - #{type1_offense_count}, 3 - #{type1_offense_count}, Total: #{total_infractions_count}"
        puts "Weights: T1 - #{type1_offense_count * 0.33}, T2 - #{type2_offense_count * 0.66}, T3 - #{type3_offense_count * 0.99}"
        puts "(#{(((type1_offense_count * 0.33) + (type2_offense_count * 0.66) + (type3_offense_count * 0.99)))} / #{total_infractions_count}) * 100"
        puts "Rating processing complete - percentage #{percentage} -  assigned rating: #{offender.offender_rating_id}"

        # save back the offender rating
        offender.save!

        # Next go scrape the handle off RSI
        scrape_results = RSIHandleScraper.scrape(rsi_handle: offender.offender_handle.to_s)

        if scrape_results
          # TODO: Verify the scrape results. This will make sure that if CIG changes anything on the page that everything doesn't explode

          # Get the basic RSI profile information
          offender.offender_handle_verified = true
          offender.offender_rsi_avatar = "https://robertsspaceindustries.com#{scrape_results[:toon_pic]}"

          # Deal with the org, if they have one
          if scrape_results[:org_rank]
            # First deal with the org itself
            offender_org = OffenderReportOrg.find_by spectrum_id: scrape_results[:org_spectrum_id].downcase
            org_exists = offender_org != nil
            offender_org = OffenderReportOrg.new unless offender_org # if it doesn't exist then make a new one

            # Only populate a new org with the spectrum_id
            offender_org.spectrum_id = scrape_results[:org_spectrum_id].downcase unless org_exists

            # Do the other org things
            offender_org.title = scrape_results[:org_title]
            offender_org.member_count = scrape_results[:org_member_count].to_i
            offender_org.model = scrape_results[:org_model]
            offender_org.commitment = scrape_results[:org_commitment]
            offender_org.primary_activity = scrape_results[:org_focus][0] if scrape_results[:org_focus][0]
            offender_org.secondary_activity = scrape_results[:org_focus][1] if scrape_results[:org_focus][1]
            offender_org.logo = "https://robertsspaceindustries.com#{scrape_results[:org_logo]}"

            puts offender_org.inspect

            # Save back the offender's org
            offender_org.save!

            offender.offender_org_rank = scrape_results[:org_rank]
            offender.org_title = scrape_results[:org_member_rank]
            offender.offender_report_org_id = offender_org.id

            # Finally update the offender again
            puts offender.inspect
            offender.save!
          end
        else
          # Need to do something here
          # If we get a 404 dont scrape this any more
          offender.dont_scrape = true
          offender.save!
        end
        puts "Finished #{offender.offender_handle}"
      else
        puts "No valid reports find for #{offender.offender_handle}."
        offender.offender_rating = nil
        offender.save!
      end
      puts ""
    end
  end
  
end
