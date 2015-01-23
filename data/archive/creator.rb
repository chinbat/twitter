require 'json'
require 'set'



json = File.read('twout7.json')
data_array = JSON.parse(json)["tweets"]
n=1000
new = File.open("new_#{n}.json",'w')

tweets = []
cnt = 0
data_array.each do |tweet|
  tweets.push(tweet)
  cnt += 1
  if cnt == n
    break
  end
end

out = {:tweets => tweets }
new.puts out.to_json