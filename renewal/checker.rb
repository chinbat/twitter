require "json"

first = 10

res = File.open("../../data/user_word_dist.txt","w")
wf = File.read("../../data/o50_json_1.txt")
data = JSON.parse(wf)["words"]
corpus = 0
data.each do |key,value|
  corpus += value
end
cnt = 0
zentai = Hash.new
data.each do |key,value|
  cnt += 1
  if cnt <= first
    zentai[key] = value.to_f/corpus
  end
end

users = [1234217384,345237117,102827762,2421485492,121013287]

result = Array.new
result[0] = zentai
for i in 1..users.length
  u = File.read("../../data/word_user/#{users[i-1]}.json")
  udata = JSON.parse(u)["words"]
  ucorpus = 0
  udata.each do |key,value|
    ucorpus += value
  end
  usage = Hash.new
  zentai.each do |key,value|
    if udata.include? key
      usage[key] = udata[key].to_f/ucorpus
    else
      usage[key] = 0
    end
  end
  result[i] = usage
end

zentai.each do |key,value|
  out = "#{key},#{value}"
  for i in 1..users.length
    out += ",#{result[i][key]}"
  end
  res.puts out
end
