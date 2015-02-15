require 'fileutils'

log_source = "/home/green/user_tweets/log"
log_target = "/media/user_tweets/log"
FileUtils.cp(log_source,log_target)
source = "/home/green/user_tweets/done_1.txt"
target = "/media/user_tweets/done_1.txt"
FileUtils.cp(source,target)

done_list = Array.new
done = File.open(target).read
done.each_line do |line|
  done_list.push(line.to_i)
end

done_list.each do |id|
  FileUtils.cp("/home/green/user_tweets/tweets/#{id}.json","/media/user_tweets/tweets/#{id}.json") unless File.exist?("/media/user_tweets/tweets/#{id}.json")
end
