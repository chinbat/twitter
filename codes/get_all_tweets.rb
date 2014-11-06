require "rubygems"
require "twitter"
require '../auth'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONKEY
  config.consumer_secret     = CONSEC 
  config.access_token        = ACCTOK 
  config.access_token_secret = ACCSEC 
end

def collect_with_max_id(collection=[], max_id=nil, &block)
  response = yield(max_id)
  collection += response
  response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def client.get_all_tweets(user)
  f = open("taro.txt","a")
  cnt = 0
  collect_with_max_id do |max_id|
    options = {:count => 200, :include_rts => true}
    options[:max_id] = max_id unless max_id.nil?     
    timeline = user_timeline(user, options)
    timeline.each do |tweet|
      f.puts tweet.text
      cnt += 1
    end
  end
  puts cnt
end

client.get_all_tweets("yu_sato92 ")

