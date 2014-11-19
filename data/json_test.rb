require 'json'
require 'set'
start = Time.now

json = File.read('225347800.json')
data_array = JSON.parse(json)["user"]
cnt = 0

puts data_array["location"] 

puts cnt
