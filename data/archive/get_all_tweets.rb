require "rubygems"
require "twitter"
require '../../yauth'

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

def client.get_all_tweets(user_id)
  f = open("#{user_id}","a")
  cnt = 0
  tweets = []
  user = user(user_id)
  collect_with_max_id do |max_id|    
    options = {:count => 200, :include_rts => true}
    options[:max_id] = max_id unless max_id.nil?     
    timeline = user_timeline(user_id, options)
    timeline.each do |tweet|
      f.puts tweet.text
      cnt += 1
    end
  end
  user_hash = {:id =>"#{user.id}",:lang =>"#{user.lang}",:location => "#{user.location}"}
  puts cnt
end

client.get_all_tweets("yu_sato92")

