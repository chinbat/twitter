require 'json'

json = File.read('twout.json')
data_array = JSON.parse(json)['tweets']
cnt = 0
start = Time.now

data_array.each do |tweet|
  cnt += 1
end
puts Time.now-start

puts cnt
