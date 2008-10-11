require 'cgi'
require 'rubygems'
require 'open-uri'
require 'JSON'

Paths = {
  'google' => :search,
  /my-site\.name/ => %r{^http://my-site\.name/(.+)\.xhtml$}
}

Jello::Mould.new do |paste, board|
  
  if paste =~ %r{^http://.*}
    uri = URI.parse $&
    unless paste =~ %r{^http://tr.im}
      # We're going to add the main part of the domain to the end of the URI
      # as a bullshit parameter, to give visitors some indication of what
      # their destination is. If you're in a character-limited location, such
      # as twitter or a text message, feel free to simply delete this section
      # of the URL by hand after pasting. (⌥⌫ is helpful!)
      # 
      # We also check if the URI matches a key of the Paths constant, and
      # process the URI based on the value matched to that key if it matches.
      # Keys can be stringish or regexish, in the latter case, it will run it
      # matches. Values can be stringish or regexish, in the latter case,
      # the last matching group will be used as the parameter.
      base = nil
      matcher = Paths.select {|matcher,baser| uri.to_s =~ (matcher.is_a?(Regexp) ? matcher : /#{matcher}/) } .first
      if matcher
        base = uri.to_s.match( matcher[1] )
      end
      
      unless base and (base = base[1])
        base = uri.host.match( /(?:[\w\d\.]+\.)?([\w\d]+)\.[\w]{2,4}/ )[1]
      end
      
      base = URI::unescape(base).gsub(/\s/, '_')
      uri = CGI::escape uri.to_s
      
      shortener = URI.parse 'http://tr.im/api/trim_url.json'
      
      # Feel free to copy this Mould to your ~/.jello directory and hardcode
      # in your username and password, if you don't feel like having your
      # username and password in your shell history.
      params = {}
      params[:username] = ENV['TRIM_USERNAME'] if ENV['TRIM_USERNAME']
      params[:password] = ENV['TRIM_PASSWORD'] if ENV['TRIM_PASSWORD']
      params[:url] = uri
      
      shortener.query = params.to_a.map {|a| a.join '=' }.join('&')
      
      begin
        puts " --@ [#{shortener}]" if $DEBUG
        reply = open(shortener).read
        short = JSON.parse reply
      rescue OpenURI::HTTPError => e
        short = {'url' => paste}
      end
      [short['url'], base].join('?')
    end
  end
  
end