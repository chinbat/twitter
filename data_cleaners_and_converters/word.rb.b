require 'json'
require 'MeCab'

start = Time.now

json = File.read('zm.json')
data_array = JSON.parse(json)["tweets"]
res = File.open("word_result.txt",'w')
c = MeCab::Tagger.new
words = Hash.new(0)

begin
$cnt = 0
data_array.each do |tweet|
  $tw = tweet
  $cnt += 1
  if tweet["text"] == ""
    next
  end
  node = c.parseToNode(tweet["text"])
  begin
    node = node.next
    word = node.surface.force_encoding("UTF-8")
    words[word] += 1
  end until node.next.feature.include?("BOS/EOS")
end
words = words.sort_by{|key, value| value}.reverse
words.each do |key, value|
  res.puts "#{key}:#{value}"
end
puts $cnt 
puts Time.now-start
rescue Exception => e
puts e.message
puts "-#{$tw["text"]}-"
puts $cnt
end  


