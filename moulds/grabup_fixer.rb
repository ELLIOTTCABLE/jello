require 'open-uri'

Jello::Mould.new do |paste|
  if paste =~ %r{^http://www\.grabup\.com/uploads/[0-9a-z]{32}\.png$}
    url = paste.gsub /#/, '%23'
    shortened_url = open("http://bit.ly/api?url=#{url}%3Fdirect").gets.chomp
    shortened_url += "?g"
  end
end