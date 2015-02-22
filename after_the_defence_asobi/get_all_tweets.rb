require "rubygems"
require "twitter"
require "../auth"

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
    f = open("../../data/after_the_defence_asobi_data/#{user}.json","a")
    cnt = 0
    tweets = Array.new
    user = user(user_id)
    collect_with_max_id do |max_id|    
      options = {:count => 200, :include_rts => true}
      options[:max_id] = max_id unless max_id.nil?     
      timeline = user_timeline(user, options)
      timeline.each do |tweet|
	# buh tweet-d n geo tag baih albagui. miniih shig.
	tweet.place? ? place_hash = {:id => "#{tweet.place.id}",:country =>"#{tweet.place.country}",:full_name => "#{tweet.place.full_name}"} : place_hash = nil
	tweet.geo? ? coordinate = "#{tweet.geo.coordinates}" : coordinate = nil
	tweet_hash = {:id => "#{tweet.id}", :created_at => "#{tweet.created_at}",:text => "#{tweet.text}",:lang =>"#{tweet.lang}",:coordinates => coordinate,:source => "#{tweet.source}",:place => place_hash}
	tweets.push(tweet_hash)
	cnt += 1
      end
    end
    user_hash = {:id =>"#{user.id}",:lang =>"#{user.lang}",:location => "#{user.location}", :count =>"#{cnt}"}
    full_hash = {:user => user_hash, :tweets => tweets}
    f.puts full_hash.to_json
  end


user = "swarovskiys16"	
client.get_all_tweets(user)
