#-*- coding: UTF-8 -*-

require 'net/http'
require 'json'
require 'fileutils'
require 'chunky_png'
require 'MeCab'
require 'uri'
require 'date'

for i in 15..17
  json_file = "twout#{i}/twout#{i}_edited.json"
  out_file = "twout#{i}.json"
  out = File.open(out_file,"w")
  json = File.read(json_file)
  data_array = JSON.parse(json)
  tweets = []
  data_array['tweets'].each do |tweet|
      lat = tweet["coordinates"][/(?<=\[).+(?=\,)/].to_f
      long = tweet["coordinates"][/(?<=\s).+(?=\])/].to_f
      nlat = ((lat-21.94)/0.02314).to_i
      nlong = ((long-123.75)/0.0225).to_i
      lat = nlat*0.02314+21.94+0.02314/2
      long = nlong*0.0225 + 123.75 + 0.0225/2
      tweet["lat"]=lat
      tweet["long"]=long
      r = /@[a-zA-Z0-9_]*/
      japanese = /(?:\p{Hiragana}|\p{Katakana}|[一-龠々]|[a-zA-Z0-9]|[.,。、ー])+/
      text = tweet["text"]
      new_text = ""
      while r.match(text)!= nil do
	text.slice! r.match(text).to_s
      end
      URI.extract(text).each do |uri|
	text.slice! uri
      end
      text.delete!("\n")
      while japanese.match(text)!=nil do
	new_text << japanese.match(text).to_s
	new_text << " "
	text.slice! japanese.match(text).to_s
      end
      tweet["text"] = new_text
      texts = []
      if new_text!=""
        c = MeCab::Tagger.new
        node = c.parseToNode(new_text)
        begin
          node = node.next
          word = node.surface.force_encoding("UTF-8")
          feature = node.feature.split(/,/)[0]
          oword = {"w"=>word,"f"=>feature}
          texts.push oword
        end until node.next.feature.include?("BOS/EOS")
      end
      tweet["words"] = texts
      tweets.push tweet
  end
  rain_hash = {:tweets => tweets}
  out.puts rain_hash.to_json
end


