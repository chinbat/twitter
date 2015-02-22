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
    f = open("../../data/user_tweets/tweets/#{user_id}.json","a")
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

  user_cnt = 0
  rate_cnt = 0
  consumer_key = OAuth::Consumer.new(CONKEY, CONSEC)
  access_token = OAuth::Token.new(ACCTOK, ACCSEC)

  ids.each_line do |line|
    id = line.to_i
    if done_list.include? id
      next
    end
    address = URI("https://api.twitter.com/1.1/users/show.json?user_id=#{id}")
    http = Net::HTTP.new address.host, address.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new address.request_uri
    request.oauth! http, consumer_key, access_token
    http.start
    response = http.request(request)
    if response.code != "200"
      log.puts "#{id} user's response was #{response.code}"
      log.close
      log = File.open(log_file,'a')
      # done list-d bichigdeegui tul asuudal garj magad
      # aldaa zaagaad garahad hamgiin suul done list-d bichigdeh id-n response code n !=200
      # baival ene id-n umnuh hurtelhiig ids-s ustgaad dahij retry hiih uydee ene id-s ehelne
      # gehdee tiim azgui yum baimaargui um
      sleep(10)
      next
    end    
    if client.user?(id)
      user = client.user(id)
      if user.statuses_count >= 3000 and !user.protected?
        prev_time = Time.now
	client.get_all_tweets(id)
        next_time = Time.now
        log.puts "Collected tweets of user #{id} at #{DateTime.now}. Time:#{next_time-prev_time}"
        log.close
        log = File.open(log_file,'a')
	done.puts id
	done.close
	user_cnt += 1
	done_list.add(id)
	done = File.open(done_file,'a')
	if user_cnt % 9 == 0
	  sleep(1000)
	end
      end
    end
    rate_cnt += 1
    if rate_cnt % 90 == 0
      sleep(1000)
    end
  end
rescue Exception => e
  puts e.message
end
