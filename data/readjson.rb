require 'json'
require 'set'
start = Time.now

json = File.read('twout1.json')
data_array = JSON.parse(json)['tweets']
cnt = 0

data_array.each do |tweet|
  if tweet["text"].include? "雨"
    cnt += 1 
    puts "#{cnt}: #{tweet['text']}"
  end
end
puts Time.now-start
puts cnt
