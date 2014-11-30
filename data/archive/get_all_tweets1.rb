require "rubygems"
require "twitter"
require '../yauth'

begin
  stdout_file = "stdout.log"
  stderr_file = "stderr.log"
  $stdout.reopen(stdout_file,'a')
  $stderr.reopen(stderr_file,'a')

  done_list = Set.new
  done = File.open('done_1.txt').read
  done.each_line do |line|
    done_list.add(line.to_i)
  end
  done = File.open('done_1.txt','a')
  ids = File.open('ids_1.txt').read
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
    f = open("user_tweets/#{user_id}.json","a")
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
  ids.each_line do |line|
    id = line.to_i
    user = client.user(id)
    if user.statuses_count >= 3000
      if !done_list.include? id
	client.get_all_tweets(id)
	done.puts id
	done.close
	user_cnt += 1
	done_list.add(id)
	done = File.open('done_1.txt','a')
	if user_cnt % 11 == 0
	  sleep(1000)
	end
      end
    end
  end
rescue Exception => e
  client.update("@chinbaa_chi Error has occured in User tweets collecting process at #{DateTime.now}.")
  puts "Erros has occured at #{DateTime.now}. Error message is: #{e.message}"
end