require 'json'
require 'set'
start = Time.now

json = File.read('twout1.json')
data_array = JSON.parse(json)['tweets']
ids = Set.new
cnt = 0
out = File.open('ids_1.txt','a')

data_array.each do |tweet|
  ids.add(tweet["user"]["id"])
end
#out.puts ids.length
# id-uud davhtsahgui
ids.each do |id|
  out.puts id
end
puts Time.now-start
