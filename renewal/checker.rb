require "json"

gf = File.read("../../data/ruiseki_100_9.goi")
data = JSON.parse(gf)["words"]
#filename = "../../data/tokucho1.goi"
filename = "../../data/word_user/2291051576.json"
#word = "twitter"
#filename = "../../data/gois/#{word}"
#f = File.foreach(filename)
f = File.read(filename)
#cnt = 0
#f.each do |coor|
#  cs = coor.split(",")
#  lat = cs[0]
#  long = cs[1]
#  freq = cs[2].to_i
#  cnt += freq
#end
#puts cnt
log = File.open("test.log","w")
fd = JSON.parse(f)["words"]
words = Hash.new
fd.each do |key,value|
  words[key] = value
end
swords = words.sort_by{|key,value| value}.reverse
swords.each do |key,value|
  if data.include? key
    log.puts "#{key},#{value}"
  end
end
#log.puts swords

#fd.each do |key,value|
#  corpus += value
#end
#puts corpus
