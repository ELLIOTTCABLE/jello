require 'uri'

Jello::Mould.new do |paste|
  if paste =~ %r{^http://.*}
    uri = URI.parse paste
    
    if uri.host =~ /grabup/
      uri.host = 'grabup.com'
      uri.query = 'direct'
      uri.to_s
    else; nil; end
  end
end
