require 'rubygems'
require 'chunky_png'
require 'set'

image = ChunkyPNG::Image.from_file('weather.png')
colors = Set.new
cnt = 0
for x in 0..255
  for y in 0..255
    if ChunkyPNG::Color.to_truecolor_bytes(image[x,y]) != [0,0,0]
      colors.add(ChunkyPNG::Color.to_truecolor_bytes(image[x,y]))
    end
  end
end

colors.each do |color|
puts color
puts
end

