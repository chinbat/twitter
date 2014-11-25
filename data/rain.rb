require 'net/http'
require 'json'
require 'fileutils'
require 'chunky_png'

json = File.read('small.json')
data_array = JSON.parse(json)
#rain = File.open('rain.json','w')

cnt = 0
$base_url = "http://weather.map.c.yimg.jp/weather?"
data_array['tweets'].each do |tweet|
  created_at = tweet["created_at"]
  year = created_at[0,4]
  month = created_at[5,2]
  day = created_at[8,2]
  hour = created_at[11,2]
  min = created_at[14,2].to_i
  min -= min % 5
  coordinates = tweet["coordinates"]
  lat = coordinates[/(?<=\[).+(?=\,)/].to_f
  long = coordinates[/(?<=\s).+(?=\])/].to_f
  ##s
  year=2014
  month=10
  day=27
  hour="08"
  min="00"
  lat = 40.98
  long = 146.24
  ##e
  plat = Math.log((1+Math.sin(lat*Math::PI/180))/(1-Math.sin(lat*Math::PI/180)))/(4*Math::PI)*64
  plong = (long+180)*64/360
  x = plong.to_i
  y = plat.to_i
  xpos = ((plong-x)*256).to_i
  ypos = ((plat-y)*256).to_i
  url = "#{$base_url}x=#{x}&y=#{y}&z=7&date=#{year}#{month}#{day}#{hour}#{min}"
  uri = URI(url)
  filename = "img/#{year}/#{month}/#{day}/x#{x}y#{y}_#{hour}#{min}.png"
  if !File.exist?(filename)
    # download png
    FileUtils::mkdir_p 'img' unless File.exist?('img')
    FileUtils::mkdir_p "img/#{year}" unless File.exist?("img/#{year}")
    FileUtils::mkdir_p "img/#{year}/#{month}" unless File.exist?("img/#{year}/#{month}")
    FileUtils::mkdir_p "img/#{year}/#{month}/#{day}" unless File.exist?("img/#{year}/#{month}/#{day}")
    response = Net::HTTP.get_response(uri)
    if response.code == "200"
      img = File.open(filename,'wb')
      img << response.body
      img.close
    else
      puts "Couldn't download png"
    end
  end
  image = ChunkyPNG::Image.from_file(filename)
  puts ChunkyPNG::Color.to_truecolor_bytes(image[xpos,ypos])
end

