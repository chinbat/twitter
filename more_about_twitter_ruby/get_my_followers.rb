require "rubygems"
require "twitter"
require '../auth'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONKEY 
  config.consumer_secret     = CONSEC 
  config.access_token        = ACCTOK 
  config.access_token_secret = ACCSEC 
end

puts client.user("chinbaa_chi")
follower_ids = client.follower_ids.to_a
count = 0
follower_ids.each do |follower|
  count += 1
end

puts count
