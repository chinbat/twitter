#-*- coding: UTF-8 -*-

require 'net/http'
require 'json'
require 'fileutils'
require 'chunky_png'
require 'MeCab'
require 'uri'
require 'date'

begin
t1 = Time.now
r = /@[a-zA-Z0-9_]*/
japanese = /(?:\p{Hiragana}|\p{Katakana}|[一-龠々]|[a-zA-Z0-9]|[.,。、ー])+/
ojap = /^(?:\p{Hiragana}|\p{Katakana}|[一-龠々]|[ー])+$/
romaji = /^[a-zA-Z]+$/
warai = /^[w]+$/
hirakata = /^(?:\p{Hiragana}|\p{Katakana})+$/
c = MeCab::Tagger.new
for i in 0..49
  json_file = "twout#{i}/twout#{i}_edited.json"
  out_file = "converted/twout#{i}.json"
  out = File.open(out_file,"w")
  json = File.read(json_file)
  data_array = JSON.parse(json)
  tweets = []
  data_array['tweets'].each do |tweet|
      text = tweet["text"]
      if text.include? "きつね" or text.include? "モンスト" or text.include? "ソフトバンクいちろー" or text.include? "12月21日にラブサンと同じ" or text.include? "首都圏はもちろん全国の風俗店やAV" or text.include? "スマホRPGは今これをやってるよ"
        next
      end
      lat = tweet["coordinates"][/(?<=\[).+(?=\,)/].to_f
      long = tweet["coordinates"][/(?<=\s).+(?=\])/].to_f
      nlat = ((lat-21.94)/0.02314).to_i
      nlong = ((long-123.75)/0.0225).to_i
      lat = nlat*0.02314+21.94+0.02314/2
      long = nlong*0.0225 + 123.75 + 0.0225/2
      tweet["latlong"]="#{lat.round(5)},#{long.round(5)}"
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
        node = c.parseToNode(new_text)
        begin
          node = node.next
          word = node.surface.force_encoding("UTF-8")
          feature = node.feature.split(/,/)[0]
          if feature != "名詞"
            next
          end
          if ojap.match(word)==nil and romaji.match(word)==nil
            next
          end
          if warai.match(word)!=nil
            next
          end
          if romaji.match(word)!=nil and word.size <=2
            next
          end
          if hirakata.match(word)!=nil and word.size == 1
            next
          end
          if romaji.match(word)!=nil
            word = word.downcase
          end
          texts.push word
        end until node.next.feature.include?("BOS/EOS")
      end
      tweet["words"] = texts
      tweets.push tweet
  end
  rain_hash = {:tweets => tweets}
  out.puts rain_hash.to_json
end
puts "Time: #{Time.now-t1}"
rescue Exception => e
  puts "#{e.message}"
end



