require 'uri'
ame = "雨,"
encoded = URI.escape(ame, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
puts encoded
