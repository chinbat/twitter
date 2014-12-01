require 'rubygems'
require 'oauth'
require 'json'
require '../auth'

def parse_response(response)
  parsed_data = nil
  if response.code == '200'
    parsed_data = JSON.parse(response.body)
    puts JSON.pretty_generate(parsed_data)
  else
    puts "Expected a response of 200 but got #{response.code} instead"
  end
  parsed_data
end


baseurl = "https://api.twitter.com"
#path = "/1.1/account/verify_credentials.json"
path = "/1.1/users/show.json?user_id=536590678"
address = URI("#{baseurl}#{path}")

# Set up Net::HTTP to use SSL, which is required by Twitter.
http = Net::HTTP.new address.host, address.port
puts http
#http.use_ssl = true
#http.verify_mode = OpenSSL::SSL::VERIFY_PEER


consumer_key = OAuth::Consumer.new(
  CONKEY, CONSEC)
access_token = OAuth::Token.new(
  ACCTOK, ACCSEC)

# Build the request and authorize it with OAuth.
request = Net::HTTP::Get.new address.request_uri
request.oauth! http, consumer_key, access_token

# Issue the request and return the response.
http.start
response = http.request(request)
puts response.code
#parse_response(response)

