#last_id = IO.readlines("/home/green/user_tweets/done_1.txt")[-1].to_i
last_id = IO.readlines("target")[-1].to_i
puts last_id

ids = File.open("ids").read

thereis = false
ids.each_line do |line|
  if line.to_i == last_id
    thereis = true
    break
  end
end

if thereis
  file = File.open("ids",'w')
  reached = false
  ids.each_line do |line|
    if !reached
      reached = true unless last_id != line.to_i
    else
      file.puts line
    end
  end
end 


