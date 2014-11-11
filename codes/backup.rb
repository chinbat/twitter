require 'fileutils'

counter_file = "/root/data/logs/count_number"
file_number = 100000
last_file = "/root/data/logs/last_file_number"
counter = File.read(counter_file).to_i
last_num = File.read(last_file).to_i
last = File.open(last_file,'w')
sleep(2)

num = counter / file_number

i =  last_num + 1

while i < num do
  FileUtils.cp("/root/data/tweets/twout#{i}.json","/media/tweets/twout#{i}.json")
  i += 1
end

last.puts num-1 
   
