require "rubygems"
require "twitter"
require '../yauth'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONKEY 
  config.consumer_secret     = CONSEC 
  config.access_token        = ACCTOK 
  config.access_token_secret = ACCSEC
end

client.update("@chinbaa_chi Hey do something.")

