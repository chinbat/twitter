file = File.open("ids_1.txt").read
cnt = 0
file.each_line do |line|
  cnt += 1
  if cnt == 1
    
  puts line.to_i
end
