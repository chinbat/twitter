require "json"

#$stdout.reopen("stdout.txt",'w')
#$stderr.reopen("stderr.txt","w")
log = File.open("new_ids.txt","w")

good_users = Array.new
good_all = File.foreach('user_ids.txt')
good_all.each do |user|
  good_users << user.to_i
end

done_users = Array.new
done_all = File.foreach("done_1.txt")
done_all.each do |user|
  done_users << user.to_i
end

all = 0
inc = 0
good_users.each do |user|
  all += 1
  if !done_users.include? user
    inc += 1
    log.puts user
  end
end

puts inc,all
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

