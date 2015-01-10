require "json"
require "fileutils"

#begin
  #$stdout.reopen("stdout.txt","a")
  #$stderr.reopen("stderr.txt","a")

  log = File.open("estimator_log.txt","w")
  valid_users = Array.new
  valid = File.foreach("valid_users")
  valid.each do |user|
    valid_users << user.to_i
  end
  
  res = File.open("estimation_res.txt","a")
  uc = 0
  aw = File.read("/home/chinbat/bunseki/o50_json.txt")
  allw = JSON.parse(aw)["words"]
  all_words = Hash.new
  allw.each do |key,value|
    all_words[key] = value
  end
  corpus = 20179133
  
  valid_users.each do |user|
    t1 = Time.now
    uc += 1
    if uc!=2
      next
    end
    coordinates = Hash.new(0)
    file = File.read("word_user/#{user}.json")
    data = JSON.parse(file)
    rloc = data["user"]["rloc"]
    data["words"].each do |key,value|
      fn = "/home/chinbat/bunseki/rapidjson/rapidjson/include/gois/#{key}"
      if File.exist?(fn)
        fw = File.foreach(fn)
        fw.each do |coor|
          t = coor.split(',')
          lat = t[0].to_f
          long = t[1].to_f
          n = t[2].to_f
          coordinate = "#{lat},#{long}"
          #puts all_words["ピル"]
          coordinates[coordinate] += value.to_f * n / corpus.to_f
          #something
        end
      end
    end
    coordinates = coordinates.sort_by{|key,value| value}.reverse
    log.puts "#{user}: #{rloc}"
    coordinates.each do |key,value|
      log.puts "#{key},#{value}"
    end
    t2 = Time.now
    log.puts "Time: #{t2-t1}"
    if uc == 2
      exit
    end
  end

#rescue Exception => e
#  log.puts e.message
#end
