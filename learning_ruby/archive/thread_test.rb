def func1
   i=0
   while i<=1000
      puts "func1 at: #{Time.now}"
      i=i+1
   end
end

def func2
   j=0
   while j<=1000
      puts "func2 at: #{Time.now}"
      j=j+1
   end
end

puts "Started At #{Time.now}"
t1=Thread.new{func1()}
t2=Thread.new{func2()}
t1.join
t2.join
puts "End at #{Time.now}"