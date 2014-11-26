require 'json'
require 'set'
start = Time.now

json = File.read('rain.json')
data_array = JSON.parse(json)["tweets"]
cnt = 0

data_array.each do |tweet|
#  if tweet["text"].include? "雨"
#    cnt += 1
#    puts tweet["created_at"]
#    puts
#  end
  cnt += 1
  puts tweet["rain"]
end
puts Time.now-start
puts cnt
