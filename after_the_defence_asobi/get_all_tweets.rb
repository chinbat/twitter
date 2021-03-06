require "rubygems"
require "twitter"
require "oauth"
require "../auth"

begin
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
    f = open("../../data/after_the_defence_asobi_data/#{user_id}.json","w")
    cnt = 0
    tweets = Array.new
    user = user(user_id)
    collect_with_max_id do |max_id|    
      options = {:count => 200, :include_rts => true}
      options[:max_id] = max_id unless max_id.nil?     
      timeline = user_timeline(user_id, options)
      timeline.each do |tweet|
	# place baihnuu ? 
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

  consumer_key = OAuth::Consumer.new(CONKEY, CONSEC)
  access_token = OAuth::Token.new(ACCTOK, ACCSEC)
  ids = [71834665,1067448344,282603491,165374536,17704579]
  ids.each do |id|
    address = URI("https://api.twitter.com/1.1/users/show.json?user_id=#{id}")
    http = Net::HTTP.new address.host, address.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new address.request_uri
    request.oauth! http, consumer_key, access_token
    http.start
    response = http.request(request)
    if client.user?(id)
      user = client.user(id)
      if user.statuses_count >= 3000 and !user.protected?
	client.get_all_tweets(id)
      end
    end
  end
rescue Exception => e
  puts e.message
end
