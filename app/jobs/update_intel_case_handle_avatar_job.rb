class UpdateIntelCaseHandleAvatarJob < ApplicationJob
  queue_as :default

  def perform(bensec_object)
    # handle value to variable
    handle_value = bensec_object.rsi_handle

    # query the page
    page = HTTParty.get("https://robertsspaceindustries.com/citizens/#{handle_value.to_s.downcase}", timeout: 15)

    # return if we dont get a 200
    return unless page.code == 200

    # get the scrape results
    scrape_results = RSIHandleScraper.scrape(rsi_handle: handle_value)

    # get the value
    avatar_value = "https://robertsspaceindustries.com#{scrape_results[:toon_pic]}"

    # set the value
    bensec_object.rsi_avatar_link = avatar_value

    # save
    bensec_object.save
  end
end
