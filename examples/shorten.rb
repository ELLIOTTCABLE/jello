($:.unshift File.expand_path(File.join( File.dirname(__FILE__), '..', 'lib' ))).uniq!
%w[jello open-uri rubygems json].each {|dep| require dep }

Jello::Mould.new do |paste, board|
  
  if paste =~ %r{^http://.*}
    uri = $&
    unless paste =~ %r{^http://tr.im}
      uri.gsub! /#/, '%23' # Fix anchors
      
      shortener = 'http://tr.im/api/trim_url.json?url=' + uri
      
      reply = open(shortener).read
      short = JSON.parse reply
      short['url']
    end
  end
  
end

Jello.start :verbose => true
