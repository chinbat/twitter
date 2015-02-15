begin
  file = open("test.txt","w")
  file.puts "line 1"
  loop{}
rescue Exception => e
  file.puts "line 2"
  puts "rescued"
  puts e.message
end
