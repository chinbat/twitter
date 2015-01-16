require 'json'

json = File.read('225347800.json')
data_array = JSON.parse(json)["tweets"]
f = File.open("225347800.txt",'w')

cnt = 0
data_array.each do |tweet|
  cnt += 1
  f.puts tweet["text"]
end

puts cnt
