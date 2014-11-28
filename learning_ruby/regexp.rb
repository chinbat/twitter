#encoding: utf-8
require 'uri'
require 'MeCab'

c = MeCab::Tagger.new
r = /@[a-zA-Z0-9_]*/
#japanese_regex = /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/
japanese_regex = /(?:\p{Hiragana}|\p{Katakana}|[一-龠々]|[a-zA-Z0-9]|[.,。、])+/
text = "@chinbaa_chi\n @Chinba_cj 私はあなたが大好きです。\n @munguun1 https://www.google.comあ ★ ℃     〜^_^ 😭  (￣∀￣) ‼️  💕  【REBEL TWO】♡  * ° "

while r.match(text)!=nil do 
  text.slice! r.match(text).to_s
end

URI.extract(text).each do |uri|
  text.slice! uri
end
puts text
text.delete!("\n")

puts text

new_text = ""
while japanese_regex.match(text)!=nil do
  new_text << japanese_regex.match(text).to_s
  new_text << " "
  text.slice! japanese_regex.match(text).to_s
end

node = c.parseToNode(new_text)
words = []

begin
  node = node.next
  words << node.surface.force_encoding("UTF-8")
end until node.next.feature.include?("BOS/EOS")

print words
