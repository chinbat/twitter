require "json"
require "fileutils"

only = File.open("../../data/only_rain_2.txt","w")

not_rain = Hash.new
nr = File.foreach("../../data/not_rain_words.txt")
nr.each do |word|
  word_sp = word.split(',')
  w = word_sp[0]
  n = word_sp[1].to_f
  if n >= 50
    not_rain[w] = n / 20665926
  end
end

rain = Array.new
r = File.foreach("../../data/rain_words.txt")
r.each do |word|
  word_sp = word.split(',')
  w = word_sp[0]
  n = word_sp[1].to_f
  if n >= 50 and not_rain.include? w
    ratio = n / 923748 / not_rain[w]
    if ratio >= 2
      only.puts "#{w},#{ratio},#{n},#{not_rain[w]}"
    end
  end
end

