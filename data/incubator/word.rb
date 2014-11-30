require 'json'
require 'MeCab'

start = Time.now

json = File.read('zm.json')
data_array = JSON.parse(json)["tweets"]
res = File.open("word_result_with_cleaner.txt",'w')
c = MeCab::Tagger.new
words = Hash.new(0)
number = /[0-9]+/
signs = /[.,。、]+/
romaji = /[a-zA-Z]+/
hiragana1 = /\p{Hiragana}/
hiragana2 = /\p{hiragana}{2,2}/



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
    if number.match(word)!=nil or signs.match(word)!=nil or (romaji.match(word)!=nil and (word.size==1 or word.size==2)) or (hiragana1.match(word)!=nil and word.size == 1) or (hiragana2.match(word)!=nil and word.size==2)
      next
    end 
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


