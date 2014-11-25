#encoding: utf-8
require 'set'
require 'json'

fields = Hash.new 

json = File.read('twout1.json')
data_array = JSON.parse(json)

cnt = 0
data_array["tweets"].each do |tweet|
  if tweet["place"] != nil
    if tweet["place"]["full_name"].include?("Chitose-shi, Hokkaido")
      puts tweet["place"]["full_name"]
      puts tweet["place"]["id"]
      exit
    end
  end
end

