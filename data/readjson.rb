require 'json'
require 'set'
start = Time.now

json = File.read('twout3_edited.json')
data_array = JSON.parse(json)["tweets"]
out = File.open('rain3.txt','w')
cnt = 0
data_array.each do |tweet|
  if tweet["rain"] != 0
    cnt += 1
    out.puts tweet["created_at"],tweet["text"],tweet["coordinates"],tweet["place"]["full_name"]
    out.puts
  end
end

puts cnt
