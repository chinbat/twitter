require 'set'
require 'json'

a = Set.new 

json = File.read('twout1.json')
data_array = JSON.parse(json)
out = File.open('out_bot.txt','w')

target = "source"
cnt =0
data_array["tweets"].each do |tweet|
  if tweet["source"].include?("bot")
    cnt += 1
    out.puts "#{cnt}:"
    out.puts tweet['created_at']
    out.puts tweet['place']['full_name'] unless tweet['place'] == nil
    out.puts tweet["text"]
    out.puts
  end
end

