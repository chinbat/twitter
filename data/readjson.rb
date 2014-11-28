require 'json'
require 'set'
start = Time.now

json = File.read('small.json')
data_array = JSON.parse(json)["tweets"]
texts = File.open('small.txt','w')

data_array.each do |tweet|
  texts.puts tweet["text"]
  puts tweet["created_at"][-4,4]
end
