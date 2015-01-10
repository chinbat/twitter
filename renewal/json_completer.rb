for i in 61..65
  filename = "twout#{i}.json"
  s = File.size(filename)
  File.truncate(filename, s-2) # ,-g ustgah

  content = File.read(filename)
  new_file = "tmp.json"
  new = File.open(new_file,'w')
  new.puts "{\"tweets\":["
  new.print content
  new.close

  File.delete(filename)
  File.rename(new_file,filename)

  f = File.open(filename,'a')
  f.print "]}"
  f.close
end



