#!/usr/bin/env ruby
# coding: utf-8

require 'openssl'
require 'net/http'
require 'uri'
require 'oauth'
require 'rubygems'
require 'json'
require '../auth'

consumer_key = OAuth::Consumer.new(
    CONKEY, CONSEC)
access_token = OAuth::Token.new(
    ACCTOK, ACCSEC)


# 取得したtweetを出力するファイルをオープン
twout = File.open('twout.csv',"w")

# streaming APIに接続
baseurl = "https://stream.twitter.com"
path = "/1.1/statuses/sample.json"
uri = URI("#{baseurl}#{path}")

#uri = URI.parse("https://stream.twitter.com/1.1/statuses/sample.json")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

# tweetの取得開始
request = Net::HTTP::Get.new(uri.request_uri)
request.oauth! http, consumer_key, access_token

http.start
twcnt = 0
http.request(request) do |response|
    puts response.code
    #raise 'Response is not chuncked' unless response.chunked?
    response.read_body do |chunk|
        # 空行は無視、JSON形式でのパースに失敗したら次へ
        status = JSON.parse(chunk) rescue next
        # 削除通知など、'text'パラメータを含まないものは無視して次へ
        next unless status['text']
        # 日本語でないtweetは無視して次へ
        next unless status['user']['lang'] == 'ja'

    # tweetの本文とクライアントの情報を出力
    twarray = [status['text'], status['source']]
    twarray.map! {|e| e.gsub(/"/, "\"\"") }
    twarray.map! {|e| "\"#{e}\"" }
    twout.puts twarray.join(",")
    twcnt += 1

    # 必要な数のtweetが収集できたら終了（ここでは40tweet）
    exit if twcnt > 10
    end
end

# ファイルをクローズ
twout.close
