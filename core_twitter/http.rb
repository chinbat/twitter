#require 'rubygems'
#require 'oauth'
#require 'json'
#require_relative '../b2auth'
require 'uri'
require 'net/http'

#consumer_key = OAuth::Consumer.new(
#  CONKEY, CONSEC)
#access_token = OAuth::Token.new(
#  ACCTOK, ACCSEC)

#baseurl = "https://api.twitter.com"
#path = "1.1/users/show.json?user_id=536590678"
#address = URI("#{baseurl}#{path}")
address = URI("http://weather.map.c.yimg.jp/weather?x=113&y=13&z=8&date=201207202020")
#address = URI("http://www.google.com")

# Set up Net::HTTP to use SSL, which is required by Twitter.
#http = Net::HTTP.new address.host, address.port
#http.use_ssl = true
#http.verify_mode = OpenSSL::SSL::VERIFY_PEER

# Build the request and authorize it with OAuth.
#request = Net::HTTP::Get.new address.request_uri
#request.oauth! http, consumer_key, access_token

# Issue the request and return the response.
#http.start
#response = http.request(request)
response = Net::HTTP.get_response(address)
puts response.code

