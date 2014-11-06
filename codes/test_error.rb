require 'date'

begin
  $cnt = 5
  raise
rescue
  counter = File.open('count_number.txt','w')
  log = File.open('log.txt','w')
  counter.puts $cnt
  log.puts 'Error has occured at'
  log.puts DateTime.now
  log.puts "cnt: #{$cnt}"
  log.puts "file size: #{File.size('twout.txt')} bytes"
end
