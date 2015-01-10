require "json"
require "set"

users = Set.new
cnt = 0
res = File.open("user_ids.txt","w")
(0..49).each do |n|
  input = File.read("converted/twout#{n}.json")
  data = JSON.parse(input)["tweets"]
  data.each do |tweet|
    cnt += 1
    users.add tweet["user"]["id"]
  end
end

users.each do |user|
  res.puts user
end

puts cnt
puts users.size
