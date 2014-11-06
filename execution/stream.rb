require "rubygems"
require "twitter"
require "json"
require '../yauth'

begin
  stdout_file = "../../data/stdout.log"
  stderr_file = "../../data/stderr.log"
  $stdout.reopen(stdout_file,'a')
  $stderr.reopen(stderr_file,'a')

  process_log_number = 1000
  file_number = 100000
  notify_number = 1000000
  kilo = 1024
  locations = ["123.75,21.94,129.375,31.95","129.375,27.05,135,36.59","135,31.95,146.25,36.59","135,36.59,146.25,40.98","135,40.98,146.25,45.08"]
  
  counter_file = "../../data/count_number"
  old_cnt = File.read(counter_file).to_i
  cnt = 0 # local counter
  twout_counter = old_cnt / file_number
  twout_file = "../../data/twout#{twout_counter}.json"
  twout = File.open(twout_file,'a') # create a file and add this if the file is new: {"tweets":[
  file_log_file = "../../data/file_log"
  file_log = File.open(file_log_file,'a')
  file_log.puts "Started to write to twout#{twout_counter}.json at #{DateTime.now}"
  file_log.close
  process_file = "../../data/process_log"
  process = File.open(process_file,'a')

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

  start = Time.now # start of this process

  client.filter(:locations => locations.join(",")) do |object|
    if object.id? && object.created? && object.geo? && object.is_a?(Twitter::Tweet)
      place_hash = {:id => "#{object.place.id}", :country => "#{object.place.country}", :full_name => "#{object.place.full_name}"} if object.place?
      user_hash = {:id => "#{object.user.id}", :lang => "#{object.user.lang}", :location => "#{object.user.location}", :geo_enabled? => "#{object.user.geo_enabled?}"} if object.user?
      tweet_hash = {:id => "#{object.id}", :created_at => "#{object.created_at}", :text => "#{object.text}", :lang => "#{object.lang}", :coordinates => "#{object.geo.coordinates}", :source => "#{object.source}", :place => place_hash, :user => user_hash}
      twout.print '    ' 
      twout.print tweet_hash.to_json
      twout.puts ','
      cnt += 1
      if cnt == process_log_number
        finish = Time.now
        diff = finish - start
        start = finish
        time = Time.new
        process.print "#{time.year}-#{time.month}-#{time.day} #{time.hour}:#{time.min}:#{time.sec}, #{diff}"
        counter = File.open(counter_file,'w')
        old_cnt += cnt
        counter.puts old_cnt
        cnt = 0
        counter.close
        twout.close
        twout = File.open(twout_file,'a')
        process.puts ", #{old_cnt}, #{File.size(twout_file)/1024}"
        process.close
        process = File.open(process_file,'a') # change it to append, after start to collect tweets
        if old_cnt % file_number == 0 
          file_log = File.open(file_log_file,'a')
          file_log.puts "Finished to write to twout#{twout_counter}.json(#{File.size("../../data/twout#{twout_counter}.json")/1024} KB) at #{DateTime.now}"
          twout_counter = old_cnt / file_number
          file_log.puts "Started to write to twout#{twout_counter}.json at #{DateTime.now}"
          file_log.close
          twout.close
          twout_file = "../../data/twout#{twout_counter}.json"
          twout = File.open(twout_file,'a')
          if old_cnt % notify_number == 0
            rest_client.update("@chinbaa_chi Process is being normal. Tweets: #{old_cnt} at #{DateTime.now}")
          end
        end
      end
    end
  end
  # end of loop
  rest_client.update("@chinbaa_chi Twitter API error has occured during the tweet collecting process at #{DateTime.now}. Do something Chinbaa!")
  puts "Twitter API error has occured at #{DateTime.now}"
rescue Exception => e 
  #rescue process here
  rest_client.update("@chinbaa_chi Ruby error has occured during the tweet collecting process at #{DateTime.now}. Do something Chinbaa!")
  puts "Ruby error has occured at #{DateTime.now}. Error message is: #{e.message}"
end

