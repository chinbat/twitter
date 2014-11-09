require 'json'

start = Time.now

json = File.read('twout7.json')
data_array = JSON.parse(json)['tweets']
cnt = 0

data_array.each do |tweet|
  cnt += 1
  #if tweet["text"] == "null"
    #puts tweet["id"]
  #end
end
puts Time.now-start

puts cnt
