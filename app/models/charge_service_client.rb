require 'rest-client'
class ChargeServiceClient
  def self.base_url
    ENV['CHARGE_SERVICE_URL'] || 'http://charge:4583'
  end

  def self.get_charges(customer, supply_point_reference, from, to, clock_time = false)
    url = "#{base_url}/#{customer}/supply-points/#{supply_point_reference}/charges/#{from.strftime('%F')}/#{to.strftime('%F')}"
    url = url += '/clock' if clock_time
    RestClient.get(url, {content_type: :json, accept: :json}) do |resp, req, result|
      {status: resp.code, body: resp.body}
    end
  end

  def self.get_consumption_summary(customer, starts, ends)
    url = "#{base_url}/customers/#{customer}/consumption/#{starts}/#{ends}/monthly"
    RestClient.get(url, {content_type: :json, accept: :json}) do |resp, req, result|
      {status: resp.code, body: resp.body}
    end
  end
end