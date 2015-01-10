require 'json'

json = File.read('twout0.json')
data_array = JSON.parse(json)["tweets"]

cnt = 0
data_array.each do |tweet|
  cnt += 1
end

puts cnt
