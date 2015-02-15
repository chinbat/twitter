require "json"

log = File.open("../../data/rain_histogram_log.txt","a")
rain_words = Hash.new(0)
rain = File.open("../../data/rain_words.txt","w")
not_rain_words = Hash.new(0)
not_rain = File.open("../../data/not_rain_words.txt","w")
t_cnt = 0
r_cnt = 0
n_cnt = 0
r_wd = 0
n_wd = 0
for i in 0..49
  t1 = Time.now
  file_name = "../../data/analysis/clean_files/converted/twout#{i}.json"
  inp_file = File.read(file_name)
  data = JSON.parse(inp_file)["tweets"]
  data.each do |tweet|
    t_cnt += 1
    if tweet["rain"]!=0
      r_cnt += 1
      tweet["words"].each do |word|
        r_wd += 1
        rain_words[word] += 1
      end
    else
      n_cnt += 1
      tweet["words"].each do |word|
        n_wd += 1
        not_rain_words[word] += 1
      end
    end
  end
  log.puts "#{i} done: #{Time.now-t1}"
  log.close
  log = File.open("../../data/rain_histogram_log.txt","a")
end
rain_words = rain_words.sort_by{|key,value| value}.reverse
not_rain_words = not_rain_words.sort_by{|key,value| value}.reverse
rain_words.each do |key,value|
  rain.puts "#{key},#{value}"
end
not_rain_words.each do |key,value|
  not_rain.puts "#{key},#{value}"
end
log.puts "Tweets: #{t_cnt}","Rain tweets: #{r_cnt}","Not rain tweets: #{n_cnt}","Rain words: #{rain_words.length},#{r_wd}","Not rain words: #{not_rain_words.length},#{n_wd}"
