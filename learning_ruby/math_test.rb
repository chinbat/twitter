latitude = ARGF.argv[0].to_f
pl = Math.log((1+Math.sin(latitude*Math::PI/180))/(1-Math.sin(latitude*Math::PI/180)))/(4*Math::PI)*64

puts pl
