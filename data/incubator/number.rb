n = 0
out = File.open("numbers.txt",'w')
File.open("word.txt").each do |line|
  n += 1
  num = line[/(?<=\:).+/].to_i
  out.puts num
end
puts n
