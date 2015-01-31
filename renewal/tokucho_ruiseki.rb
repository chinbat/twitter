require "json"

words_file = File.read("../../data/cut_gois_1.txt")
words = JSON.parse(words_file)["words"]
log = File.open("../../data/ruiseki_10_7_hist.log","w")
tokucho = File.open("../../data/ruiseki_10_7.goi_hist","w")
limit = 10
perc = 0.7
warai = /^[w]+$/ 

map = Hash.new

words.each do |key,value|
#  if key!="笑"
#    next
#  end
  if warai.match(key)!=nil
    next
  end
  filename = "../../data/trans_gois_1/#{key}"
  coordinates = Hash.new
  sum_value = 0
  File.foreach(filename).each do |coor|
    coors = coor.split(",")
    lat = coors[0]
    long = coors[1]
    freq = coors[2].to_f
    coordinate = "#{lat},#{long}"
    coordinates[coordinate] = freq
    sum_value += freq
  end
  frequency = coordinates.sort_by{|key,value| value}.reverse
  cnt = 0
  len = coordinates.length
  cnt_all = 0
  frequency.each do |key1,value1|
    cnt_all += value1
    cnt += 1
    if cnt_all.to_f/sum_value >= perc
      break
    end
  end
  if cnt <= limit
    map[key] = value
  end
end

smap = map.sort_by{|key,value| value}.reverse

nsmap = {:words => smap}.to_json
tokucho.puts nsmap
puts map.length
