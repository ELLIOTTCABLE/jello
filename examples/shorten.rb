require 'open-uri'

($:.unshift File.expand_path(File.join( File.dirname(__FILE__), '..', 'lib' ))).uniq!
require 'jello'

Jello.new :verbose => true do |paste, board|

  case paste

  when %r%^http://%
    uri = $&
    uri.gsub! /#/, '%23'
    next if uri =~ %r%^http://bit.ly%

    shortener = 'http://bit.ly/api?url=' + uri

    short = open(shortener).gets.chomp
    board.puts short

  end

end.start
