#encoding: utf-8
require 'uri'
require 'MeCab'

c = MeCab::Tagger.new
r = /@[a-zA-Z0-9_]*/
japanese_regex = /(?:\p{Hiragana}|\p{Katakana}|[一-龠々]|[a-zA-Z0-9]|[.,。、])+/
number = /[0-9]+/
signs = /[.,。、]+/
romaji = /[a-zA-Z]+/
hiragana1 = /\p{Hiragana}/
hiragana2 = /\p{hiragana}{2,2}/
word = "hello"

if !(number.match(word)!=nil or signs.match(word)!=nil or (romaji.match(word)!=nil and (word.size==1 or word.size==2)) or (hiragana1.match(word)!=nil and word.size == 1) or (hiragana2.match(word)!=nil and word.size==2))
  puts word
end
