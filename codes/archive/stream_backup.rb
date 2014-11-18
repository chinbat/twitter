require "rubygems"
require "twitter"
require "json"
require '../yauth'

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = CONKEY 
  config.consumer_secret     = CONSEC 
  config.access_token        = ACCTOK 
  config.access_token_secret = ACCSEC 
end

cnt = 0
#twout = File.open('twout.txt',"w")
#start = Time.now
#twout.puts '{"tweets":['
client.filter(:locations => "135.0,31.95,146.25,45.08") do |object|
    if object.id? && object.created?
        puts object.text
        cnt += 1
        #place_hash = {:country => "#{object.place.country}", :full_name => "#{object.place.full_name}", :id => "#{object.place.id}"} if object.place?
        #user_hash = {:id => "#{object.user.id}", :lang => "#{object.user.lang}", :location => "#{object.user.location}", :geo_enabled? => "#{object.user.geo_enabled?}"} if object.user?
        #geo_hash = {:coordinates => "#{object.geo.coordinates}"} if object.geo?
        #tweet_hash = {:id => "#{object.id}", :created_at => "#{object.created_at}", :text => "#{object.text}", :lang => "#{object.lang}", :source => "#{object.source}", :geo => geo_hash, :place => place_hash, :user => user_hash}
        #JSON.pretty_generate(JSON.generate(tweet_hash))
        #twout.puts JSON.generate(tweet_hash) if object.is_a?(Twitter::Tweet)
        if cnt >= 10
            #finish = Time.now
            #diff = finish - start
            #puts "Elapsed time: #{diff}"
            #twout.puts ']}'
            exit
        end
    end
end


