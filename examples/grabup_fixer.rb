require 'open-uri'

($:.unshift File.expand_path(File.join( File.dirname(__FILE__), '..', 'lib' ))).uniq!
require 'jello'

Jello.new :verbose => ARGV.include?('-v') do |paste, board|
  next unless paste =~ %r{^http://www\.grabup\.com/uploads/[0-9a-z]{32}\.png$}

  url = paste.gsub /#/, '%23'
  shortened_url = open("http://bit.ly/api?url=#{url}%3Fdirect").gets.chomp
  board.puts shortened_url
end.start
