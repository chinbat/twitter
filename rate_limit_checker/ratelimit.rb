require 'rubygems'
require 'oauth'
require 'json'
require '../yauth'

def check_blist(response)
  if response.code == '200'
    resources = JSON.parse(response.body)['resources']
    puts resources["statuses"]["/statuses/user_timeline"]["remaining"]
  else 
    puts "Expected a response of 200 but got #{response.code} instead"
  end
end

# All requests will be sent to this server.
baseurl = "https://api.twitter.com"
path = "/1.1/application/rate_limit_status.json"


# The verify credentials endpoint returns a 200 status if
# the request is signed correctly.
address = URI("#{baseurl}#{path}")

# Set up Net::HTTP to use SSL, which is required by Twitter.
http = Net::HTTP.new address.host, address.port
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

consumer_key = OAuth::Consumer.new(
  CONKEY, CONSEC)
access_token = OAuth::Token.new(
  ACCTOK, ACCSEC)

# Build the request and authorize it with OAuth.
request = Net::HTTP::Get.new address.request_uri
request.oauth! http, consumer_key, access_token

# Issue the request and return the response.
http.start
response = http.request request
check_blist(response)

