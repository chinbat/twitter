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

dup_log = File.open("../../data/dup_tweet.log","w")
tweet_dup = File.open("../../data/tweet_dup_word.log","w")
valid_users = Array.new
valid = File.foreach("../../data/valid_users")
valid.each do |user|
  valid_users << user.to_i
end

#tokucho = File.read("../../data/o50_json_1.txt")
tokucho = File.read("../../data/ruiseki_10_7.goi")
tokucho_f = JSON.parse(tokucho)["words"]
tokucho_goi = Array.new
tokucho_f.each do |key,value|
  tokucho_goi << key
end


all_words = 0
all_dup = 0
all_freq = 0
toku_words = 0
toku_dup = 0
uc = 0
for i in 1900..1999
  user = valid_users[i]
  uc += 1
  json_file = "../../data/word_user/#{user}.json"
  file = File.read(json_file)
  data = JSON.parse(file)
  words = Hash.new(0)
  tokucho_words = Hash.new(0)
  all_tweets = data["user"]["count"].to_i
  u_wds = 0
  u_dup = 0
  uw_dup = 0
  data['tweets'].each do |tweet|
      tweet_words = Hash.new(0)
      text = tweet["text"]
      if text.include? "きつね" or text.include? "モンスト" or text.include? "ソフトバンクいちろー" or text.include? "12月21日にラブサンと同じ" or text.include? "首都圏はもちろん全国の風俗店やAV" or text.include? "スマ
ホRPGは今これをやってるよ"
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
          tweet_words[word] += 1
          u_wds += 1
        end until node.next.feature.include?("BOS/EOS")
      end
      tweet_words.each do |key,value|
        if value > 1
          u_dup += 1
          break
        end
      end
      word_dup = 0
      word_dup_cnt = 0
      tweet_words.each do |key,value|
        if value > 1
          word_dup_cnt += 1
          word_dup += value
        end
      end
      if word_dup_cnt != 0
        uw_dup += word_dup.to_f/word_dup_cnt
      end
      tweet_words.each do |key,value|
        if value > 1
          words[key] += value
          if tokucho_goi.include? key
            tokucho_words[key] += value
          end
        end
      end
  end
  dup_log.puts "#{u_dup.to_f/all_tweets*100}"
  tweet_dup.puts "#{uw_dup.to_f/u_dup}"  
  all_words += words.length
  cnt = 0
  words.each do |key,value|
    cnt += value
  end
  all_dup += cnt
  all_freq += u_wds
  toku_words += tokucho_words.length
  cnt = 0
  tokucho_words.each do |key,value|
    cnt += value
  end
  toku_dup += cnt
end
puts "words: #{all_words/uc}"
puts "dup: #{all_dup/uc}"
puts "freq: #{all_freq/uc}"
puts "toku_words: #{toku_words/uc}"
puts "toku_dup: #{toku_dup/uc}"



rescue Exception => e
  puts "#{e.message}"
end

