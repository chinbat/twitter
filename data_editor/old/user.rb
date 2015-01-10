require "json"

#$stdout.reopen("stdout.txt",'w')
#$stderr.reopen("stderr.txt","w")

ov = File.open("valid_users.txt","w")
users = Array.new
input = File.foreach('users_list.txt')
input.each do |user|
  users << user.to_i
end
u=0
users.each do |user|
  file = File.read("tweets/#{user}.json")
  data = JSON.parse(file)["user"]["count"].to_i
  if data > 3000
    ov.puts user
    u+=1
  end
end


puts u
