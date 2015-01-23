require "json"

log = File.open("../../data/cut_gois.txt","w")
aw = File.read("../../data/o50_json.txt")
allw = JSON.parse(aw)["words"]
nw = Hash.new
all = 0
allw.each do |key,value|
  ifile = "../../data/gois/#{key}"
  ofile = "../../data/cut_gois/#{key}"
  i = File.foreach(ifile)
  o = File.open(ofile,"w")
  cnt = 0
  c = 0
  c_all = 0
  i.each do |coor|
    c_all += 1
    cs = coor.split(",")
    lat = cs[0]
    long = cs[1]
    freq = cs[2].to_i
    if freq > 10
      c += 1
      o.puts "#{lat},#{long},#{freq}" 
      cnt += freq
    end
  end
  if c != 0
    #log.puts "#{key},#{c},#{cnt},#{c_all},#{value}"
    nw[key] = cnt
    all += cnt
  end
end
puts all
nw = nw.sort_by{|key,value| value}.reverse
nws = {:words=>nw}.to_json
log.puts nws
