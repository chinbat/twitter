require "json"

coors = File.open("../../data/cut_coordinates.txt","w")
aw = File.read("../../data/cut_gois.txt")
allw = JSON.parse(aw)["words"]

coordinates = Hash.new(0)
allw.each do |key,value|
  filename = "../../data/cut_gois/#{key}"
  File.foreach(filename) do |coor|
    cs = coor.split(",")
    lat = cs[0]
    long = cs[1]
    freq = cs[2].to_i
    coordinates["#{lat},#{long}"] += freq
  end
end
new_coor = coordinates.sort_by{|key,value| value}.reverse
coors.puts new_coor.to_json

allw.each do |key,value|
  ifile = "../../data/cut_gois/#{key}"
  ofile = "../../data/trans_gois/#{key}"
  i = File.foreach(ifile)
  o = File.open(ofile,"w")
  i.each do |coor|
    cs = coor.split(",")
    lat = cs[0]
    long = cs[1]
    coordinate = "#{lat},#{long}"
    freq = cs[2].to_f
    o.puts "#{lat},#{long},#{freq/coordinates[coordinate]}"
  end
end
