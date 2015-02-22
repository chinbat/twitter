#-*- coding: UTF-8 -*-

require 'net/http'
require 'json'
require 'fileutils'
require 'chunky_png'
require 'MeCab'
require 'uri'
require 'date'

begin

r = /@[a-zA-Z0-9_]*/
japanese = /(?:\p{Hiragana}|\p{Katakana}|[一-龠々]|[a-zA-Z0-9]|[.,。、ー])+/
ojap = /^(?:\p{Hiragana}|\p{Katakana}|[一-龠々]|[ー])+$/
romaji = /^[a-zA-Z]+$/
warai = /^[w]+$/
hirakata = /^(?:\p{Hiragana}|\p{Katakana})+$/
c = MeCab::Tagger.new

log = File.open("convert_log.txt","a")
valid_users = [1067448344,282603491,165374536,71834665,17704579]
uc = 0

valid_users.each do |user|
  t1 = Time.now
  uc += 1
  json_file = "../../data/after_the_defence_asobi_data/#{user}.json"
  out_file = "../../data/after_the_defence_asobi_data/w#{user}.json"
  file = File.read(json_file)
  data = JSON.parse(file)
  out = File.open(out_file,"w")
  words = Hash.new(0)
  data['tweets'].each do |tweet|
      text = tweet["text"]
      if text.include? "きつね" or text.include? "モンスト" or text.include? "ソフトバンクいちろー" or text.include? "12月21日にラブサンと同じ" or text.include? "首都圏はもちろん全国の風俗店やAV" or text.include? "スマホRPGは今これをやってるよ"
        next
      end
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
          words[word] += 1
        end until node.next.feature.include?("BOS/EOS")
      end
  end
  data["words"] = words
  out.puts data.to_json
  t2 = Time.now
  log.puts "#{uc}: #{user} #{words.size}words Time: #{t2-t1}"
  log.close
  log = File.open("convert_log.txt","a")
end
rescue Exception => e
  puts "#{e.message}"
end



