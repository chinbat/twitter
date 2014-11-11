require 'net/http'
require 'date'

begin

cnt_file = "/media/img/cnt_num"
$cnt = File.read(cnt_file).to_i
$base_url = "http://weather.map.c.yimg.jp/weather?"
$dir = "/media/img/201207/"
first = Time.new(2012,7,28,10,25)
target = Time.new(2012,7,28,10,25)
date = first
log_file = "/media/img/log"
$log = File.open(log_file,'a')
error_file = "/media/img/error"
$error = File.open(error_file,'a')

def save_img(x,y,date)
  date.month < 10 ? month = "0#{date.month}" : month = date.month
  date.day < 10 ? day = "0#{date.day}" : day = date.day
  date.hour < 10 ? hour = "0#{date.hour}" : hour = date.hour
  date.min < 10 ? min = "0#{date.min}" : min = date.min
  date_string = "#{date.year}#{month}#{day}#{hour}#{min}"
  url = "#{$base_url}x=#{x}&y=#{y}&z=7&date=#{date_string}"
  uri = URI(url)
  filename = "#{$dir}x#{x}y#{y}d#{date_string}.png"
  response = Net::HTTP.get_response(uri)
  if response.code == "200"
    img = File.open(filename,'wb')
    img << response.body
    img.close
    $log.puts "#{x},#{y},#{date_string},#{File.size(filename)}"
    $cnt += 1
  elsif response.code == "403" or response.code == "503"
    $error.puts "Error: x=#{x} y=#{y} date=#{date_string}"
    cnt_num = File.open(cnt_file,'w')
    cnt_num.puts $cnt
    cnt_num.close
    exit
  elsif response.code == "404"
    $error.puts "No date: x=#{x} y=#{y} date=#{date_string}"
  end
end

while date <= target do
  save_img(54,4,date)
  save_img(54,5,date)
  save_img(55,5,date)
  save_img(55,6,date)
  save_img(56,6,date)
  save_img(56,7,date)
  save_img(56,8,date)
  save_img(57,6,date)
  save_img(57,7,date)
  save_img(57,8,date)
  date += 300
  cnt_num = File.open(cnt_file,'w')
  cnt_num.puts $cnt
  cnt_num.close
  # log-g bas end haaj nee.
end

rescue Exception => e
  $error.puts e.message
end
