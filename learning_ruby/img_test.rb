require 'rubygems'
require 'chunky_png'

image = ChunkyPNG::Image.from_file('test.png')
puts ChunkyPNG::Color.to_truecolor_bytes(image[300,400])
