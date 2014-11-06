require "rubygems"
require "twitter"
require "json"
require '../yauth'

begin
  old_cnt = File.read('../../data/count_number').to_i # 0 at start time
  cnt = 0
  twout = File.open('../../data/twout.json','a') # change it to append, after start to collect tweets

  client = Twitter::Streaming::Client.new do |config|
    config.consumer_key        = CONKEY 
    config.consumer_secret     = CONSEC 
    config.access_token        = ACCTOK 
    config.access_token_secret = ACCSEC 
  end

  rest_client = Twitter::REST::Client.new do |config|
    config.consumer_key        = CONKEY 
    config.consumer_secret     = CONSEC 
    config.access_token        = ACCTOK 
    config.access_token_secret = ACCSEC 
  end

  process = File.open('../../data/process_log','a') # change it to append, after start to collect tweets
  start = Time.now
  #twout.puts '{"tweets":['
  locations = ["123.75,21.94,129.375,31.95","129.375,27.05,135,36.59","135,31.95,146.25,36.59","135,36.59,146.25,40.98","135,40.98,146.25,45.08"]
  client.filter(:locations => locations.join(",")) do |object|
    if object.id? && object.geo? && object.created? && object.is_a?(Twitter::Tweet)
      cnt += 1
      place_hash = {:id => "#{object.place.id}", :country => "#{object.place.country}", :full_name => "#{object.place.full_name}"} if object.place?
      user_hash = {:id => "#{object.user.id}", :lang => "#{object.user.lang}", :location => "#{object.user.location}", :geo_enabled? => "#{object.user.geo_enabled?}"} if object.user?
      tweet_hash = {:id => "#{object.id}", :created_at => "#{object.created_at}", :text => "#{object.text}", :lang => "#{object.lang}", :coordinates => "#{object.geo.coordinates}", :source => "#{object.source}", :place => place_hash, :user => user_hash}
      twout.print '	' 
      twout.print tweet_hash.to_json
      twout.puts ','
      if cnt % 1000 == 0 
        finish = Time.now
        diff = finish - start
        start = finish
        time = Time.new
        process.print "#{time.year}-#{time.month}-#{time.day} #{time.hour}:#{time.min}:#{time.sec}, #{diff}"
        counter = File.open('../../data/count_number','w')
        old_cnt += cnt
        counter.puts old_cnt
        cnt = 0
        counter.close
        twout.close()
        twout = File.open('../../data/twout.json','a') # change it to append, after start to collect tweets        
        #twout.puts ']}'
        process.puts ", #{old_cnt}, #{File.size('../../data/twout.json')/1024}"
        process.close
        process = File.open('../../data/process_log','a') # change it to append, after start to collect tweets
      end
      if old_cnt % 100000 == 0 and old_cnt > 1
        rest_client.update("@chinbaa_chi Process is being normal. Tweets: #{old_cnt} at #{DateTime.now}")
      end
    end
  end

rescue Exception => e 
  # rescue process here
  rest_client.update("@chinbaa_chi Error has occured during the tweet collecting process at #{DateTime.now}. Do something Chinbaa!")
  old_cnt += cnt
  counter = File.open('../../data/count_number','w')
  counter.puts old_cnt
  time = Time.new
  process.print "#{time.year}-#{time.month}-#{time.day} #{time.hour}:#{time.min}:#{time.sec}, #{Time.now-start}"
  process.puts ", #{old_cnt}, #{File.size('../../data/twout.json')/1024}" 
  log = File.open('../../data/error_log','a')
  log.puts 'Error has occured at'
  log.puts DateTime.now
  log.puts "cnt: #{old_cnt+cnt}"
  log.puts "size of file twout.json: #{File.size('../../data/twout.json')/1024} KB"
  log.puts e.message
  log.puts 
end

