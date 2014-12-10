require 'net/http'
require 'json'
require 'fileutils'
require 'chunky_png'
require 'MeCab'
require 'uri'
require 'date'

def create_url(created_at, coordinates)
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
  lat = coordinates[/(?<=\[).+(?=\,)/].to_f
  long = coordinates[/(?<=\s).+(?=\])/].to_f
  #puts lat,long
  plat = Math.log((1+Math.sin(lat*Math::PI/180))/(1-Math.sin(lat*Math::PI/180)))/(4*Math::PI)*64
  plong = (long+180)*64/360
  x = plong.to_i
  y = plat.to_i
  $xpos = ((plong-x)*256).to_i
  $ypos = ((plat-y)*256).to_i
  url = "#{$base_url}x=#{x}&y=#{y}&z=7&date=#{$year}#{$month}#{$day}#{hour}#{min}"
  $uri = URI(url)
  $filename = "img/#{$year}/#{$month}/#{$day}/x#{x}y#{y}_#{hour}#{min}.png"
  $tweet_log.puts "url:#{$uri}, filename:#{$filename}, "
end

def def_rain
  if !File.exist?("#{$base_dir}#{$filename}")
    # download pnn
    FileUtils::mkdir_p "#{$base_dir}img" unless File.exist?("#{$base_dir}img")
    FileUtils::mkdir_p "#{$base_dir}img/#{$year}" unless File.exist?("#{$base_dir}img/#{$year}")
    FileUtils::mkdir_p "#{$base_dir}img/#{$year}/#{$month}" unless File.exist?("#{$base_dir}img/#{$year}/#{$month}")
    FileUtils::mkdir_p "#{$base_dir}img/#{$year}/#{$month}/#{$day}" unless File.exist?("#{$base_dir}img/#{$year}/#{$month}/#{$day}")
    $next_yahoo = Time.now
    if ($png_cnt + $no_png_cnt) != 0 and ($png_cnt + $no_png_cnt) % 40000 == 0 and ($next_yahoo-$yahoo_start) < 24*60*60 
      $crawler_log.puts "Reached #{$png_cnt + $no_png_cnt} and sleep for #{24*60*60-$next_yahoo+$yahoo_start+60*60}sec"
      $crawler_log.close
      $crawler_log = File.open($crawler_log_file,'a')
      sleep(24*60*60-$next_yahoo+$yahoo_start+60*60)
    end
    response = Net::HTTP.get_response($uri)
    if response.code == "200"
      $png_log.puts "Downloaded #{$base_dir}#{$filename}"
      $png_cnt += 1
      img = File.open("#{$base_dir}#{$filename}",'wb')
      img << response.body
      img.close
      if $png_cnt == 48000
        $logs.puts "png_cnt reached 48000"
        exit
      end
    elsif response.code == "403"
      # write log
      $log.puts "Exceeded ratelimit. #{DateTime.now}"
      exit
      #exceeded ratelimit
    elsif response.code == "404"
      $png_log.puts "Not found #{$uri}"
      $no_png_cnt += 1
      $rain_v = 16
      return
      #not found
    else
      # write log
      $png_log.puts "Unexpected response code #{$uri}. #{DateTime.now}"
      $no_png_cnt += 1
      $rain_v = 16
      return
    end
  end
  if File.exist?("#{$base_dir}#{$filename}")
    image = ChunkyPNG::Image.from_file("#{$base_dir}#{$filename}")
    color = ChunkyPNG::Color.to_hex(image[$xpos,255-$ypos], include_alph = false)
    case color
    when "#000000"
      $rain_v = 0
      $rain_cnt0 += 1
    when "#ccffff"
      $rain_v = 1
    when "#66ffff"
      $rain_v = 2
    when "#00ccff"
      $rain_v = 3
    when "#0099ff"
      $rain_v = 4
    when "#3366ff"
      $rain_v = 5
    when "#33ff00"
      $rain_v = 6
    when "#33cc00"
      $rain_v = 7
    when "#199900"
      $rain_v = 8
    when "#ffff00"
      $rain_v = 9
    when "#ffcc00"
      $rain_v = 10
    when "#ff9900"
      $rain_v = 11
    when "#ff5066"
      $rain_v = 12
    when "#ff0000"
      $rain_v = 13
    when "#b70014"
      $rain_v = 14
    else
      $rain_v = 15 # other colors
      $rain_cnt15 += 1
    end
    $tweet_log.print "readed png, "
  else
    $log.puts "$filename not exist. Have no idea. #{DateTime.now}"
  end 
end

def mecaber(old_text)
  text = old_text
  new_text = ""
  c = MeCab::Tagger.new
  r = /@[a-zA-Z0-9_]*/
  japanese = /(?:\p{Hiragana}|\p{Katakana}|[一-龠々]|[a-zA-Z0-9]|[.,。、ー])+/
  while r.match(text)!= nil do
    text.slice! r.match(text).to_s
  end
  URI.extract(text).each do |uri|
    text.slice! uri
  end
  text.delete!("\n")
  while japanese.match(text)!=nil do
    new_text << japanese.match(text).to_s
    new_text << " "
    text.slice! japanese.match(text).to_s
  end
  new_text
end

begin
$yahoo_start = Time.now
$crawler_log_file = "/home/green/wimgs/log.txt"
$crawler_log = File.open($crawler_log_file,'a')
$base_url = "http://weather.map.c.yimg.jp/weather?"
$base_dir = "/home/green/wimgs/"
error_file = "#{$base_dir}error_log.txt"
error_log = File.open(error_file,'a')
for i in 16..39
  json_target = "twout#{i}"
  $local_base_dir = "/home/green/wimgs/#{json_target}/"
  FileUtils::mkdir_p "#{$local_base_dir}" unless File.exist?("#{$local_base_dir}")
  stdout_file = "#{$local_base_dir}stdout.log"
  stderr_file = "#{$local_base_dir}stderr.log"
  $stdout.reopen(stdout_file,'w')
  $stderr.reopen(stderr_file,'w')

  start = Time.now
  json_file = "#{$base_dir}twouts/#{json_target}.json"
  png_log_file = "#{$local_base_dir}#{json_target}_png_log.txt"
  out_file = "#{$local_base_dir}#{json_target}_edited.json"
  log_file = "#{$local_base_dir}#{json_target}_log.txt"
  tweet_log_file = "#{$local_base_dir}#{json_target}_tweet_log.txt"
  puts json_file
  json = File.read(json_file)
  data_array = JSON.parse(json)
  $png_log = File.open(png_log_file,'w')
  rain = File.open(out_file,'w')
  $log = File.open(log_file,'w')
  $tweet_log = File.open(tweet_log_file,'w')
  cnt_all = 0 # all
  geo_cnt = 0 # geo_enabled == false
  plc_cnt = 0 # place == nil
  ctd_cnt = 0 # timezone != 0900
  c_cnt = 0 # country != Japan
  l_cnt = 0 # lang != ja
  cnt = 0 # normal
  $rain_cnt0 = 0 # rain 0
  $rain_cnt15 = 0 # other color
  $png_cnt = 0 # downloaded png
  $no_png_cnt = 0 # can't download
  tweets = []
  data_array['tweets'].each do |tweet|
    tweet_start = Time.now
    cnt_all += 1
    $tweet_log.print "Tweet:#{tweet['id']}, #{DateTime.now}, "
    # if not normal tweet, then remove that tweet
    if tweet["user"]["geo_enabled?"]!="true"
      $tweet_log.print "geo_enabled=false, "
      geo_cnt += 1
    elsif tweet["place"]==nil
      plc_cnt += 1
      $tweet_log.print "no place, "
    elsif tweet["created_at"][-4,4]!="0900"
      ctd_cnt += 1
      $tweet_log.print "timezone not 0900, "
    elsif tweet["place"]["country"]!="日本"
      c_cnt += 1
      $tweet_log.print "not japan, "
    elsif tweet["lang"]!="ja"
      l_cnt += 1
      $tweet_log.print "not japanese, "
    else
      #normal tweet
      $tweet_log.print "normal, "
      cnt += 1


      create_url(tweet["created_at"], tweet["coordinates"])

      rain_start = Time.now
      def_rain
      tweet["rain"] = $rain_v
      rain_end = Time.now

      mecab_start = Time.now
      old_text = tweet["text"]
      new_text = mecaber(old_text)
      tweet["text"]=new_text
      mecab_end = Time.now
      tweets.push tweet
      $tweet_log.puts "RainTime:#{rain_end-rain_start}, MeCabTime:#{mecab_end-mecab_start}, UsedTime:#{mecab_end-tweet_start}"
      $tweet_log.puts
    end
  end
  rain_hash = {:tweets => tweets}
  rain.puts rain_hash.to_json
  $log.puts "Converted #{json_file} to #{out_file} #{DateTime.now}"
  $log.puts "geo:#{geo_cnt}, plc:#{plc_cnt}, ctd:#{ctd_cnt}, country:#{c_cnt}, lang:#{l_cnt}, rain_cnt0:#{$rain_cnt0}, rain_cnt15:#{$rain_cnt15}, cnt:#{cnt}, cnt_all:#{cnt_all}, png_cnt: #{$png_cnt}, no_png_cnt:#{$no_png_cnt}"
  finish = Time.now
  $log.puts "Whole spent time: #{finish-start}" 
  $crawler_log.puts "Processed #{json_target} at #{DateTime.now}. Spent time: #{finish-start}"
  $crawler_log.puts "geo:#{geo_cnt}, plc:#{plc_cnt}, ctd:#{ctd_cnt}, country:#{c_cnt}, lang:#{l_cnt}, rain_cnt0:#{$rain_cnt0}, rain_cnt15:#{$rain_cnt15}, cnt:#{cnt}, cnt_all:#{cnt_all}, png_cnt: #{$png_cnt}, no_png_cnt:#{$no_png_cnt}"
  $crawler_log.close
  $crawler_log = File.open($crawler_log_file,'a')
end
rescue Exception => e
  error_log.puts "#{e.message}"
  error_log.puts DateTime.now
  error_log.puts 
  # may exceeded ratelimit
end



