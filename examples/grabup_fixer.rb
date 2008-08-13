require 'open-uri'

($:.unshift File.expand_path(File.join( File.dirname(__FILE__), '..', 'lib' ))).uniq!
require 'jello'

Jello.new :verbose => ARGV.include?('-v') do |paste, board|

  case paste
  when %r{^http://www\.grabup\.com/uploads/[0-9a-z]{32}\.png$}
    uri = $&
    uri.gsub! /#/, '%23'
    next if uri =~ %r{^http://bit.ly}

    shortener = "http://bit.ly/api?url=#{uri}%3Fdirect"

    short = open(shortener).gets.chomp
    board.puts short

  end

end.start
