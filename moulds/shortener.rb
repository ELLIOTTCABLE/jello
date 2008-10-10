require 'cgi'
require 'rubygems'
require 'open-uri'
require 'JSON'

Jello::Mould.new do |paste, board|
  
  if paste =~ %r{^http://.*}
    uri = URI.parse $&
    unless paste =~ %r{^http://tr.im}
      # We're going to add the main part of the domain to the end of the URI
      # as a bullshit parameter, to give visitors some indication of what
      # their destination is. If you're in a character-limited location, such
      # as twitter or a text message, feel free to simply delete this section
      # of the URL by hand after pasting. (⌥⌫ is helpful!)
      base = uri.host.match( /([\w\d\.]+\.)?([\w\d]+)\.[\w]{2,4}/ )[2]
      
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
      
      reply = open(shortener).read
      short = JSON.parse reply
      [short['url'], base].join('?')
    end
  end
  
end