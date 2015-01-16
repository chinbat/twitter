require "json"
require "fileutils"

KERNEL = [
[0,0,0,0,0.000001,0.000001,0.000001,0,0,0,0],
[0,0,0.000001,0.000014,0.000055,0.000088,0.000055,0.000014,0.000001,0,0],
[0,0.000001,0.000036,0.000362,0.001445,0.002289,0.001445,0.000362,0.000036,0.000001,0],
[0,0.000014,0.000362,0.003672,0.014648,0.023204,0.014648,0.003672,0.000362,0.000014,0],
[0.000001,0.000055,0.001445,0.014648,0.058433,0.092564,0.058433,0.014648,0.001445,0.000055,0.000001],
[0.000001,0.000088,0.002289,0.023204,0.092564,0.146632,0.092564,0.023204,0.002289,0.000088,0.000001],
[0.000001,0.000055,0.001445,0.014648,0.058433,0.092564,0.058433,0.014648,0.001445,0.000055,0.000001],
[0,0.000014,0.000362,0.003672,0.014648,0.023204,0.014648,0.003672,0.000362,0.000014,0],
[0,0.000001,0.000036,0.000362,0.001445,0.002289,0.001445,0.000362,0.000036,0.000001,0],
[0,0,0.000001,0.000014,0.000055,0.000088,0.000055,0.000014,0.000001,0,0],
[0,0,0,0,0.000001,0.000001,0.000001,0,0,0,0]
]

aw = File.read("../../data/o50_json.txt")
allw = JSON.parse(aw)["words"]
all_words = Array.new
allw.each do |key,value|
  all_words.push key
end

def coor2xy(lat,long)
  y = (lat-21.95157)/0.02314
  x = (long-123.76125)/0.0225
  return x.round,y.round
end

def xy2coor(x,y)
  lat = y * 0.02314 + 21.95157
  long = x * 0.0225 + 123.76125
  return lat.round(5),long.round(5)
end

#for i in 0..all_words.length-1
for i in 0..0
  t1 = Time.now
  $coordinates = Hash.new(0)
  def smoother(x,y,n)
    for j in 0..9
      for k in 0..9
        lat,long = xy2coor(x-5+j,y-5+k)      
        $coordinates["#{lat},#{long}"] += n * KERNEL[j][k]
      end
    end
  end
  #word = all_words[i]
  word = "うどん"
  file = "../../data/gois/#{word}"
  out_file = "../../data/smooth_gois/#{word}"
  out = File.open(out_file,"w")
  fw = File.foreach(file)
  c = 0
  fw.each do |coor|
    c += 1
    t = coor.split(',')
    lat = t[0].to_f
    long = t[1].to_f
    n = t[2].to_i
    x,y = coor2xy(lat,long)
    if x > 9 and x < 989 and y > 9 and y < 989
      smoother(x,y,n)
    end
  end
  cnt = 0
  $coordinates.each do |key,value|
    rounded = value.round(5)
    if rounded != 0
      cnt += 1
      out.puts "#{key},#{rounded}"
    end
  end
  puts c,cnt,$coordinates.length
  puts Time.now-t1
end



