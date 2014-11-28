require 'json'
require 'set'
start = Time.now

json = File.read('500_edited.json')
data_array = JSON.parse(json)["tweets"]
res = File.open("checker_result.txt","w")

cnt = 0
data_array.each do |tweet|
  if tweet["rain"] != 0
    cnt += 1
    res.puts tweet["rain"],tweet["text"]
    res.puts
  end
end

res.puts cnt
