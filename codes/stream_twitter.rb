require "rubygems"
require "twitter"
require "json"
require '../yauth'

begin

  client = Twitter::Streaming::Client.new do |config|
    config.consumer_key        = CONKEY 
    config.consumer_secret     = CONSEC 
    config.access_token        = ACCTOK 
    config.access_token_secret = ACCSEC 
  end

  $cnt = File.read('count_number.txt').to_i
  #$cnt = 0
  #twout = File.open('twout.txt','a')
  twout = File.open('twout.txt','w')
  start = Time.now
  twout.puts '{"tweets":['
  client.filter(:locations => "135.0,31.95,146.25,45.08") do |object|
    if object.id? && object.created? && object.is_a?(Twitter::Tweet)
      cnt += 1
      place_hash = {:id => "#{object.place.id}", :country => "#{object.place.country}", :full_name => "#{object.place.full_name}"} if object.place?
      user_hash = {:id => "#{object.user.id}", :lang => "#{object.user.lang}", :location => "#{object.user.location}", :geo_enabled? => "#{object.user.geo_enabled?}"} if object.user?
      tweet_hash = {:id => "#{object.id}", :created_at => "#{object.created_at}", :text => "#{object.text}", :lang => "#{object.lang}", :coordinates => "#{object.geo.coordinates}", :source => "#{object.source}", :place => place_hash, :user => user_hash} if object.geo?
      twout.print '	'
      twout.print tweet_hash.to_json
      if cnt >= 100
        finish = Time.now
        diff = finish - start
        puts "Elapsed time: #{diff}"
        twout.puts
        twout.puts ']}'
        exit
      else
        twout.puts ','
      end
    end
  end

rescue
  # rescue process here
  client.update('@chinbaa_chi Error has occured during the tweet collecting process. Do something Chinbaa!')
  counter = File.open('count_number.txt','w')
  log = File.open('log.txt','a')
  counter.puts $cnt
  log.puts 'Error has occured at'
  log.puts DateTime.now
  log.puts "cnt: #{$cnt}"
  log.puts "file size: #{File.size('twout.txt')} bytes"
end

  

