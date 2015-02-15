require "rubygems"
require "twitter"
require_relative 'auth'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONKEY 
  config.consumer_secret     = CONSEC 
  config.access_token        = ACCTOK 
  config.access_token_secret = ACCSEC
end

client.update("Shine doloo honogiin mend hurgey! Ene doloo honogoo amjilt buteeleer duuren unguruuleerei. #{DateTime.now}")

