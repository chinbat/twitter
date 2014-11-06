require "rubygems"
require "twitter"
require '../auth'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONKEY 
  config.consumer_secret     = CONSEC 
  config.access_token        = ACCTOK 
  config.access_token_secret = ACCSEC
end

object = client.status("529844052137476097")
string = object.text
hash = {"text" => string}
json = JSON.generate(hash)
puts JSON.parse(json)["text"]
