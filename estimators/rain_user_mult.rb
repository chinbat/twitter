require "date"
require "json"
require "fileutils"
require "uri"
require "net/http"
require "chunky_png"

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
  #$stdout.reopen("../../data/rain_1_stdout","w")
  #$stderr.reopen("../../data/rain_1_stderr","w")
  $log = File.open("../../data/user_rain_mult_1000_new.txt","a")
  valid_users = Array.new
  valid = File.foreach("../../data/new_valid_user")
  valid.each do |user|
    valid_users << user.to_i
  end
  
  limit = 100
  
  for i in 0..999
    user = valid_users[i]
    res = File.open("../../data/res_rain_mult_new/#{user}","w")
    rain_r = File.foreach("../../data/res_rain/#{user}")
    rain_coor = Hash.new
    max_rain = 0
    rain_r.each do |coor|
      cs = coor.split(",")
      lat = cs[0]
      long = cs[1]
      value = cs[2].to_f
      if value > max_rain
        max_rain = value
      end
      rain_coor["#{lat},#{long}"] = value
    end
   
    coor_cnt = 0
    all_coors = File.foreach("../../data/res_tokucho_userbase/#{user}.json")
    all_coors.each do |coor|
      coor_cnt += 1
    end
    
    if coor_cnt == 0
      puts "yes"
      next
    end
    c_cnt = 0
    $all_c = Hash.new
    all_coors.each do |coor|
      c_cnt += 1
      cs = coor.split(",")
      lat = cs[0]
      long = cs[1]
      value = cs[2].to_f
      $all_c["#{lat},#{long}"] = value
      if c_cnt == limit
        break
      end
    end

    f = File.read("../../data/word_user/#{user}.json")
    data = JSON.parse(f)

    rloc = data["user"]["rloc"]
    rloc_sp = rloc.split(',')
    rlat = rloc_sp[0].to_f
    rlon = rloc_sp[1].to_f
 
    $res_coor = Hash.new
    if rain_coor.length != 0 
      $all_c.each do |key,value|
        if rain_coor.include? key
          $res_coor[key] = value * rain_coor[key]/max_rain
        else
          $res_coor[key] = value * 1 / max_rain
        end
      end
      sorted = $res_coor.sort_by{|key,value| value}.reverse
      sorted.each do |key,value|
        res.puts "#{key},#{value}"
      end
    else
      $res_coor = $all_c 
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

    $log.puts "#{i},#{user},#{rlat},#{rlon},#{first_num},#{first_num_10},#{num},#{$all_c.length},#{sorted.length},#{sorted[0][1]},#{all_point},#{all_dist/10},#{Math.sqrt(all_dist2/10-all_dist*all_dist/100)}"
    $log.close
    #log_rain.close
    $log = File.open("../../data/user_rain_mult_1000_new.txt","a")
    #log_rain = File.open("../../data/user_rain_char","a") 
  end
rescue Exception=>e
  puts e.message
end
