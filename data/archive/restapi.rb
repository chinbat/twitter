require 'json'
require 'twitter'
require '../yauth'

start = Time.now

client = Twitter::REST::Client.new do |config|
  config.consumer_key = CONKEY
  config.consumer_secret = CONSEC
  config.access_token = ACCTOK
  config.access_token_secret = ACCSEC
end

json = File.read('twout1.json')
data_array = JSON.parse(json)['tweets']
cnt = 0

data_array.each do |tweet|
  user = client.user(tweet["user"]["id"].to_i)
  cnt += 1
  if user.statuses_count > 3000
    puts user.id
  end
  if cnt > 5
    break
  end
end
puts Time.now-start
puts cnt
