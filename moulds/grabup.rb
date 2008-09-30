require 'open-uri'

Jello::Mould.new do |paste|
  if paste =~ %r{^http://www\.grabup\.com/uploads/[0-9a-z]{32}\.png$}
    paste.gsub!(%r{^http://www\.}, 'http://')
    paste += '?direct'
  end
end