require "date"
require "json"
require "fileutils"
require "uri"
require "net/http"
require "chunky_png"

def check_rain(created_at)
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
  created = DateTime.new($year.to_i,$month.to_i,$day.to_i,hour.to_i,min.to_i)
  limit = DateTime.new(2012,7,20,20,20)
  if created < limit
    return
  end
  $valid_rains += 1
  cnt = 0
  $all_c.each do |coor|
    t1 = Time.now
#    cnt += 1
#    if cnt % 10 == 0
#      puts cnt
#    end
    sc = coor.split(",")
    lat = sc[0].to_f
    long = sc[1].to_f
    plat = Math.log((1+Math.sin(lat*Math::PI/180))/(1-Math.sin(lat*Math::PI/180)))/(4*Math::PI)*64
    plong = (long+180)*64/360
    x = plong.to_i
    y = plat.to_i
    $xpos = ((plong-x)*256).to_i
    $ypos = ((plat-y)*256).to_i
    url = "#{$base_url}x=#{x}&y=#{y}&z=7&date=#{$year}#{$month}#{$day}#{hour}#{min}"
    if $not_found.include? url
      next
    end
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
      else
        $not_found.push url
      end
    end
    if File.exist?("#{$base_dir}#{$filename}")
      image = ChunkyPNG::Image.from_file("#{$base_dir}#{$filename}")
      color = ChunkyPNG::Color.to_hex(image[$xpos,255-$ypos], include_alph = false)
      if color != "#000000"
        $res_coor[coor] += 1
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



begin
  $stdout.reopen("../../data/rain_stdout","w")
  $stderr.reopen("../../data/rain_stderr","w")
  $base_url = "http://weather.map.c.yimg.jp/weather?"
  $base_dir = "../../data/img/"
  rain_words = ["雨降り","生憎","大雨","傘","雨","小雨","あめ","雷","アマ","高潮","中止","警報","カッパ","停電","予報","雪","足元","遅延","津波","強風","防災","気圧","hpa"]
  $log = File.open("../../data/user_rain.txt","a")
#  log_rain = File.open("../../data/user_rain_char","a")

  $not_found = Array.new
  valid_users = Array.new
  valid = File.foreach("../../data/new_valid_user")
  valid.each do |user|
    valid_users << user.to_i
  end
  
  limit = 100
  
  for i in 135..999
#  for i in 0..0
    t2 = Time.now
#    puts i
    user = valid_users[i]
    res = File.open("../../data/res_rain/#{user}","w")
    coor_cnt = 0
    all_coors = File.foreach("../../data/res_tokucho_userbase/#{user}.json")
    all_coors.each do |coor|
      coor_cnt += 1
    end
   # puts "cand: #{coor_cnt}"
    c_cnt = 0
    $all_c = Array.new
    all_coors.each do |coor|
      c_cnt += 1
      cs = coor.split(",")
      lat = cs[0]
      long = cs[1] 
      $all_c << "#{lat},#{long}"
      if c_cnt == limit
        break
      end
    end

    f = File.read("../../data/word_user/#{user}.json")
    data = JSON.parse(f)
    cnt = 0

    rloc = data["user"]["rloc"]
    rloc_sp = rloc.split(',')
    rlat = rloc_sp[0].to_f
    rlon = rloc_sp[1].to_f

    rains = 0
    $valid_rains = 0
    $res_coor = Hash.new(0)
    data["tweets"].each do |tweet|
      rain_words.each do |rword|
        if tweet["text"].include? rword
          #puts tweet["text"]
          time = tweet["created_at"]
          check_rain time
          rains += 1
          break
        end
      end
    end
    #puts "rains: #{rains}"
    #puts "res: #{$res_coor}"    
    if $res_coor.length == 0
      next
    end
    sorted = $res_coor.sort_by{|key,value| value}.reverse
    sorted.each do |key,value|
      res.puts "#{key},#{value}"
    end

    #log_rain.puts "#{i},#{user},#{rlat},#{rlon},#{rains},#{$valid_rains},#{sorted.length}"

    cr_cnt = 0
    size = 101
    num = size
    first_num =size
    first_num_10 =size
    flag = true
    flag_10 = true
    all_point = 0
    all_dist = 0
    all_dist2 = 0
    sorted.each do |key,value|
      all_point += value.to_i
      cr_cnt += 1
      if key == rloc
        num = cr_cnt
      end
      t = key.split(",")
      lat = t[0].to_f
      lon = t[1].to_f
      dist = distance(rlat,rlon,lat,lon)
      if cr_cnt <= 10
        all_dist += dist
        all_dist2 += dist*dist
      end
      if flag and dist<=160
        first_num = cr_cnt
        flag = false
      end
      if flag_10 and dist <= 10
        first_num_10 = cr_cnt
        flag_10 = false
      end
    end

    t3 = Time.now
    time = t3-t2
    $log.puts "#{i},#{user},#{rlat},#{rlon},#{first_num},#{first_num_10},#{num},#{$all_c.length},#{rains},#{$valid_rains},#{sorted.length},#{sorted[0][1]},#{all_point},#{all_dist/10},#{Math.sqrt(all_dist2/10-all_dist*all_dist/100)},#{time}"
    $log.close
    #log_rain.close
    $log = File.open("../../data/user_rain.txt","a")
    #log_rain = File.open("../../data/user_rain_char","a") 
  end
rescue Exception=>e
  puts e.message
end
