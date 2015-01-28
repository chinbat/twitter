require "json"
require "fileutils"

$base_url = "http://weather.map.c.yimg.jp/weather?"
$base_dir = "../../data/img/"

def check_rain(created_at, coordinates)
  $year = created_at[0,4]
  $month = created_at[5,2]
  $day = created_at[8,2]
  hour = created_at[11,2]
  min = created_at[14,2].to_i
  min -= min % 5
  if min == 0
    min = "00"
  elsif min == 5
    min = "05"
  end
  coordinates.each do |key,value|
    sc = key.split(",")
    lat = sc[0]
    long = sc[1]     
    plat = Math.log((1+Math.sin(lat*Math::PI/180))/(1-Math.sin(lat*Math::PI/180)))/(4*Math::PI)*64
    plong = (long+180)*64/360
    x = plong.to_i
    y = plat.to_i
    $xpos = ((plong-x)*256).to_i
    $ypos = ((plat-y)*256).to_i
    url = "#{$base_url}x=#{x}&y=#{y}&z=7&date=#{$year}#{$month}#{$day}#{hour}#{min}"
    $uri = URI(url)
    $filename = "#{$year}/#{$month}/#{$day}/x#{x}y#{y}_#{hour}#{min}.png"
    if !File.exist?("#{$base_dir}#{$filename}")
      FileUtils::mkdir_p "#{$base_dir}" unless File.exist?("#{$base_dir}")
      FileUtils::mkdir_p "#{$base_dir}#{$year}" unless File.exist?("#{$base_dir}#{$year}")
      FileUtils::mkdir_p "#{$base_dir}#{$year}/#{$month}" unless File.exist?("#{$base_dir}#{$year}/#{$month}")
      FileUtils::mkdir_p "#{$base_dir}#{$year}/#{$month}/#{$day}" unless File.exist?("#{$base_dir}#{$year}/#{$month}/#{$day}")
      http = Net::HTTP.new($uri.host,$uri.port)
      request = Net::HTTP::Get.new $uri.request_uri
      http.start
      response = http.request(request)
      if response.code == "200"
        img = File.open("#{$base_dir}#{$filename}",'wb')
        img << response.body
        img.close
      elsif response.code == "403"
        puts "rate limit exceeded"
      elsif response.code == "404"
        puts "not found"
      else
        puts "no idea"
      end
      if File.exist?("#{$base_dir}#{$filename}")
        image = ChunkyPNG::Image.from_file("#{$base_dir}#{$filename}")
        color = ChunkyPNG::Color.to_hex(image[$xpos,255-$ypos], include_alph = false)
        if color != "#000000"
          puts "it's rain"
        end
      end
    end
  end
end


R = 6371
def distance(lat1,lon1,lat2,lon2)
  dlat = deg2rad(lat2-lat1)
  dlon = deg2rad(lon2-lon1)
  a = Math.sin(dlat/2) * Math.sin(dlat/2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dlon/2) * Math.sin(dlon/2)
  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
  d = R * c
  return d
end

def deg2rad(deg)
  return deg * (Math::PI/180)
end

rain_words = ["雨降り","生憎","大雨","傘","雨","小雨","あめ","雷","アマ","高潮","中止","警報","カッパ","停電","予報","雪","足元","遅延","津波","強風","防災","気圧","hpa"]


begin
  #$stdout.reopen("stdout.txt","a")
  #$stderr.reopen("stderr.txt","a")
  $log = File.open("../../data/user_rain.txt","w")

  valid_users = Array.new
  valid = File.foreach("../../data/new_valid_user")
  valid.each do |user|
    valid_users << user.to_i
  end
  
  uc = 0
#  aw = File.read("../../data/o50_json.txt")
  aw = File.read("../../data/tokucho1.goi")
  allw = JSON.parse(aw)["words"]
  all_words = Hash.new
  allw.each do |key,value|
    all_words[key] = value
  end
#  corpus = 20179133
  #for i in 5001..valid_users.length-1

  for i in 70..70
    t1 = Time.now
    #user = valid_users[i]
    user = "239544804"
    #user = "1173665124"
    f = File.read("../../data/word_user/#{user}.json")
    fd = JSON.parse(f)["words"]
    cnt = 0
    fd.each do |key,value|
      if all_words.include? key
        cnt += 1
        puts key
      end
    end
    puts fd.length
    puts cnt
    exit
    if !File.exist?("../../data/est_res_tokucho/#{user}.json")
      next
    end
    coordinates0 = Hash.new
    coordinates1 = Hash.new
    coors = File.foreach("../../data/est_res_tokucho/#{user}.json")
    coors.each do |coor|
      sc = coor.split(",")
      lat = sc[0]
      long = sc[1]
      freq = sc[2].to_f
      coordinates1["#{lat},#{long}"] = freq.to_f
      if freq!=0
        coordinates0["#{lat},#{long}"] = freq.to_f
      end
    end
    $log.puts "#{user},#{coordinates0.length},#{coordinates1.length}"
    next
    uc += 1
    #res = File.open("../../data/est_res/#{user}.txt","w")
    #coordinates = Hash.new(0)
    rloc = data["user"]["rloc"]
    rloc_sp = rloc.split(',')
    rlat = rloc_sp[0].to_f
    rlon = rloc_sp[1].to_f
    rains = 0
    data["tweets"].each do |tweet|
      rain_words.each do |rword|
        if tweet["text"].include? rword
          time = tweet["created_at"]
          check_rain time,coordinates
          rains += 1
          break
        end
      end
    end
  end
rescue Exception=>e
  puts e.message
end
