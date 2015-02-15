require "json"
require "set"

log = File.open("rain_log.txt","a")
valid_users = Array.new
valid = File.foreach("valid_users")
valid.each do |user|
  valid_users << user.to_i
end

user_cnt = valid_users.size
done_user = File.open("done_user.txt","a")
uc = 0
base_url = "http://weather.map.c.yimg.jp/weather?"

valid_users.each do |user|
  t1 = Time.now
  uc += 1
  file = File.read("tweets/#{user}.json")
  out = File.open("loc_user/#{user}.json","w")
  data = JSON.parse(file)
  #determining average position
  coordinates = Hash.new(0)
  tmp = ""
  data["tweets"].each do |tweet|
    if tweet["coordinates"]!=nil
      lat = tweet["coordinates"][/(?<=\[).+(?=\,)/].to_f
      long = tweet["coordinates"][/(?<=\s).+(?=\])/].to_f
      nlat = ((lat-21.94)/0.02314).to_i
      nlong = ((long-123.75)/0.0225).to_i
      rlat = nlat*0.02314 + 21.94 + 0.02314/2
      rlong = nlong*0.0225 + 123.75 + 0.0225/2
      tweet["latlong"] = "#{rlat.round(5)},#{rlong.round(5)}"
      coordinates[tweet["latlong"]] += 1
    end
=begin
    cr = tweet["created_at"]
    year = cr[0,4]
    month = cr[5,2]
    day = cr[8,2]
    hour = cr[11,2]
    min = cr[14,2].to_i
    min -= min % 5
    if min == 0
      min = "00"
    elsif min ==5
      min = "05"
    end
    plat = Math.log((1+Math.sin(lat*Math::PI/180))/(1-Math.sin(lat*Math::PI/180)))/(4*Math::PI)*64
    plong = (long+180)*64/360
    x = plong.to_i
    y = plat.to_i
    xpos = ((plong-x)*256).to_i
    ypos = ((plat-y)*256).to_i
    url = "#{base_url}x=#{x}&y=#{y}&z=7&date=#{year}#{month}#{day}#{hour}#{min}.png"
    uri = URI(url)
    filename = "img/#{year}/#{month}/#{day}/x#{x}y#{y}_#{hour}#{min}.png"
=end
  end
  coordinates = coordinates.sort_by{|key,value| value}.reverse
  data["user"]["rloc"] = coordinates[0][0]
  #coordinates.each do |key,value|
  #   log.puts "#{key},#{value}"
  #end
  #log.puts coordinates
  #if uc == 1
  #  exit
  #end
  #adding rain feature
  out.puts data.to_json
  t2 = Time.now
  log.puts "#{uc}: #{user} Time: #{t2-t1}"
  log.close
  log = File.open("rain_log.txt","a")
end
