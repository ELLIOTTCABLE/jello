($:.unshift File.expand_path(File.join( File.dirname(__FILE__), '..', 'lib' ))).uniq!
%w[jello open-uri rubygems json].each {|dep| require dep }

Jello.new :verbose => true do |paste, board|

  if paste =~ %r{^http://.*}
    uri = $&
    uri.gsub! /#/, '%23' # Fix anchors
    next if uri =~ %r{^http://tr.im}

    shortener = 'http://tr.im/api/trim_url.json?url=' + uri

    short = JSON.parse open(shortener).read
    board.puts short['url']
  end

end.start
