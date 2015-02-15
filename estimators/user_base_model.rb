require "json"
require "fileutils"


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

#begin
  #$stdout.reopen("stdout.txt","a")
  #$stderr.reopen("stderr.txt","a")

  log = File.open("../../data/estimator_log.txt","a")
  valid_users = Array.new
  valid = File.foreach("../../data/new_valid_user")
  valid.each do |user|
    valid_users << user.to_i
  end
  
  uc = 0
  aw = File.read("../../data/o50_json.txt")
  allw = JSON.parse(aw)["words"]
  all_words = Hash.new
  allw.each do |key,value|
    all_words[key] = value
  end
  corpus = 20179133
  #for i in 5001..valid_users.length-1
  for i in 0..1000
    t1 = Time.now
    user = valid_users[i]
    uc += 1
    res = File.open("../../data/est_res/#{user}.txt","w")
    coordinates = Hash.new(0)
    file = File.read("../../data/word_user/#{user}.json")
    data = JSON.parse(file)
    rloc = data["user"]["rloc"]
    rloc_sp = rloc.split(',')
    rlat = rloc_sp[0].to_f
    rlon = rloc_sp[1].to_f
    u_corpus = 0
    data["words"].each do |key,value|
      fn = "../../data/gois/#{key}"
      if File.exist?(fn)
        u_corpus += value.to_f
      end
    end
    data["words"].each do |key,value|
      fn = "../../data/gois/#{key}"
      if File.exist?(fn)
        fw = File.foreach(fn)
        fw.each do |coor|
          t = coor.split(',')
          lat = t[0].to_f
          long = t[1].to_f
          n = t[2].to_f
          coordinate = "#{lat},#{long}"
          coordinates[coordinate] += value.to_f * n / all_words[key] * data["words"][key] / u_corpus
          # new model below
        end
      end
    end
    coordinates = coordinates.sort_by{|key,value| value}.reverse
    #log.puts "#{user}: #{rloc}"
    cr_cnt = 0
    num = 0
    first_num = 0
    first_num_10 = 0
    flag = true
    flag_10 = true
    all_prob = 0
    all_dist = 0
    all_dist2 = 0
    coordinates.each do |key,value|
      all_prob += value.to_f
      cr_cnt += 1
      if key == rloc
        num = cr_cnt
      end
      t = key.split(',')
      lat = t[0].to_f
      lon = t[1].to_f
      dist = distance(rlat,rlon,lat,lon)
      if cr_cnt <= 10
        all_dist += dist
        all_dist2 += dist * dist
      end
      #all_dist += dist
      if flag and dist <= 160
        first_num = cr_cnt
        flag = false
      end
      if flag_10 and dist <= 10
        first_num_10 = cr_cnt
        flag_10 = false
      end
      res.puts "#{key},#{value}"
    end
    t2 = Time.now
    log.puts "#{uc},#{user},#{rloc},#{first_num},#{first_num_10},#{num},#{coordinates.length},#{coordinates[0][1]},#{all_prob},#{all_dist/10},#{Math.sqrt(all_dist2/10-all_dist*all_dist/100)},#{t2-t1}"
    log.close
    log = File.open("../../data/estimator_log.txt","a")
  end

#rescue Exception => e
#  log.puts e.message
#end
