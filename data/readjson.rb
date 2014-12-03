require 'json'
require 'set'
start = Time.now

json = File.read('twout3_edited.json')
data_array = JSON.parse(json)["tweets"]
out = File.open('coordinates.txt','w')
cnt = 0
data_array.each do |tweet|
  coordinates = tweet["coordinates"]
  lat = coordinates[/(?<=\[).+(?=\,)/].to_f
  long = coordinates[/(?<=\s).+(?=\])/].to_f
  out.puts "#{lat},#{long}"
end

puts cnt
