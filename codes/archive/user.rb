require "rubygems"
require "twitter"
require '../auth'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONKEY 
  config.consumer_secret     = CONSEC 
  config.access_token        = ACCTOK 
  config.access_token_secret = ACCSEC 
end

puts client.user?("chinbaa_chi")
