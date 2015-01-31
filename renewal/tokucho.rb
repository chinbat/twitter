require "json"

words_file = File.read("../../data/cut_gois_1.txt")
words = JSON.parse(words_file)["words"]
log = File.open("../../data/ratio_3_hist.log","w")
tokucho = File.open("../../data/ratio_3_hist.goi","w")
limit = 0.03
warai = /^[w]+$/ 

map = Hash.new

words.each do |key,value|
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
  len = coordinates.length
  log.puts "#{key},#{len},#{value}"
  if sum_value/len >= limit
    map[key] = value
  end
end

smap = map.sort_by{|key,value| value}.reverse

nsmap = {:words => smap}.to_json
tokucho.puts nsmap
puts map.length
