require 'json'
require 'set'
start = Time.now

json = File.read('zm.json')
data_array = JSON.parse(json)["tweets"]
res = File.open("雨.txt","w")

cnt = 0
data_array.each do |tweet|
  if tweet["text"].include? "雨"
    cnt += 1
    res.puts tweet["coordinates"],tweet["text"]
  end
end

res.puts cnt
res.puts Time.now-start
