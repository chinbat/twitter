#-*- coding: UTF-8 -*-

require 'json'
require 'date'

begin
t1 = Time.now
for i in 0..49
  json_file = "converted/twout#{i}.json"
  out_file = "short_json/twout#{i}.json"
  out = File.open(out_file,"w")
  json = File.read(json_file)
  data_array = JSON.parse(json)
  tweets = []
  data_array['tweets'].each do |tweet|
      new_tweet = {:coordinates => "#{tweet["latlong"]}", :words => tweet["words"]}
      tweets.push new_tweet
  end
  new_hash = {:tweets => tweets}
  out.puts new_hash.to_json
end
puts "Time: #{Time.now-t1}"
rescue Exception => e
  puts "#{e.message}"
end



