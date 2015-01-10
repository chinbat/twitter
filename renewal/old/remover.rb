require "json"
require "fileutils"

good_users = Array.new
good_all = File.foreach('bad_ids.txt')
cnt = 0
good_all.each do |user|
  FileUtils.rm("tweets/#{user.to_i}.json")
  cnt += 1
end

puts cnt
=begin
users.each do |user|
  cnt = 0
  file = File.read("tweets/#{user}.json")
  data = JSON.parse(file)
  #data["tweets"].each do |tweet|  
    #if tweet["coordinates"]!=nil
      #cnt += 1
    #end
  #end
  if data["user"]["lang"] == "ja"
    u += 1
  end
  #if cnt > 100 and data["user"]["count"].to_i > 3000 
    #u += 1
  #end
end

puts u
=end

