require "json"
require "set"

users = Set.new
cnt = 0
(0..49).each do |n|
  input = File.read("/home/green/wimgs/twouts/twout#{n}.json")
  data = JSON.parse(input)["tweets"]
  data.each do |tweet|
    cnt+=1
    users.add tweet["user"]["id"]
  end
end

puts users.include? "71834665"
puts cnt
puts users.size
