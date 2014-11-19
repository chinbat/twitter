def test(collection = [], id = 5, &block)
  puts "test"
  yield(id)
  collection.push(id)
  test(collection, id-1,&block) unless id == 0 
end

def method
  test do |id|
    puts "id: #{id}"
  end
end

method
