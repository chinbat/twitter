require 'net/http'
require 'date'


first = Time.new(2012,7,28,10,25)
target = Time.new(2014,11,13,10,25)

puts (target-first)/300
