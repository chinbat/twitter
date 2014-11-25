require 'set'
require 'json'

fields = Hash.new 

json = File.read('twout1.json')
data_array = JSON.parse(json)
out_file = "place_full_name_hash.txt"
out = File.open(out_file,'w')

cnt = 0
data_array["tweets"].each do |tweet|
  if tweet["user"]["geo_enabled?"] == false
    cnt += 1
  end
end

puts cnt
