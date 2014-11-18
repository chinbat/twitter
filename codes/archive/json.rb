require 'json'

text = "chinbat/ bainaa \\ a\s"
hash = {:"name" => "#{text}"}
puts JSON.generate(hash)
