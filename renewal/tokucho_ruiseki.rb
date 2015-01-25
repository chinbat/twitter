require "json"

words_file = File.read("../../data/o50_json.txt")
words = JSON.parse(words_file)["words"]
log = File.open("../../data/tokucho1.log","w")
tokucho = File.open("../../data/tokucho1.goi","w")
limit = 5
warai = /^[w]+$/ 

map = Hash.new

words.each do |key,value|
#  if key!="駅"
#    next
#  end
  if warai.match(key)!=nil
    next
  end
  filename = "../../data/gois/#{key}"
  coordinates = Hash.new
  File.foreach(filename).each do |coor|
    coors = coor.split(",")
    lat = coors[0]
    long = coors[1]
    freq = coors[2].to_i
    coordinate = "#{lat},#{long}"
    coordinates[coordinate] = freq
  end
  frequency = coordinates.sort_by{|key,value| value}.reverse
  all = 0
  cnt = 0
  len = coordinates.length
  frequency.each do |key1,value1|
    all += value1
  end
  cnt_all = 0
  frequency.each do |key1,value1|
    cnt_all += value1
    cnt += 1
    if cnt_all.to_f/all >= 0.9
      break
    end
  end
  if cnt <= 10
    tokucho.puts key
  end
  log.puts "#{key},#{len},#{value}"
  if value.to_f/len >= 10
    map[key] = value
  end
end

smap = map.sort_by{|key,value| value}.reverse

nsmap = {:words => smap}.to_json
tokucho.puts nsmap
puts map.length
