require 'httparty'

class USPSMail
  def initialize country, total_value, total_weight, origin_postalcode, dest_postalcode
    @country = country
    @total_value = total_value
    @total_weight = total_weight
    @origin_postalcode = origin_postalcode
    @dest_postalcode = dest_postalcode
  end

  def calculate
    if @country != nil && @total_value != nil && @total_weight != nil && @origin_postalcode != nil && @dest_postalcode != nil
      if @country.code.downcase == 'us'
        domestic_shipping
      else
        international_shipping
      end
    else
      { code: 1, message: 'Passed information incomplete cannot calculate shipping.' }
    end
  end

  private
  def domestic_shipping
    mailService = 'FIRST CLASS' #FIRST CLASS, PRIORITY
    mailType = 'LETTER'

    if @total_weight > 13
      mailService = 'PRIORITY'
    end

    usps_url= "http://production.shippingapis.com/ShippingAPI.dll?API=RateV4&xml=<RateV4Request USERID=\"#{Rails.application.credentials.usps_user}\"><Revision>2</Revision><Package ID=\"1ST\"><Service>#{mailService}</Service><FirstClassMailType>#{mailType}</FirstClassMailType><ZipOrigination>#{@origin_postalcode}</ZipOrigination><ZipDestination>#{@dest_postalcode}</ZipDestination><Pounds>0</Pounds><Ounces>#{@total_weight}</Ounces><Container/><Size>REGULAR</Size><Machinable>true</Machinable></Package></RateV4Request>"

    response = HTTParty.get(usps_url)
    if response.code != 404
      { code: 0, rate: response["RateV4Response"]["Package"]["Postage"]["Rate"].to_f, message: 'Rate retrieved from USPS.'}
    else
      puts "Error Occured with USPS API request"
      { code: 1, message: 'Error occured with USPS API request. Please try again later or check with an executive staff member on Discord' }
    end
  end

  private
  def international_shipping
    # TODO: Make this actually work :)
    { code: 2, message: 'International shipping is not currently supported but we will be adding it soon! Check back later or ask one of the executive staff!' }
  end
end
