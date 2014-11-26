#encoding: utf-8
require 'uri'
require 'MeCab'

c = MeCab::Tragger.new
r = /@[a-z0-9_]*/
text = "@chinbaa_chi 私はあなたが大好きです。\n @munguun1 https://www.google.comあ ★ ℃     〜^_^ 😭  (￣∀￣) ‼️  💕  【REBEL TWO】"

while r.match(text)!=nil do 
  text.slice! r.match(text).to_s
end

URI.extract(text).each do |uri|
  text.slice! uri
end
text.delete!("\n")

puts c.parse(text)
