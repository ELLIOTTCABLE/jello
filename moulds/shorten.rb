require 'cgi'
require 'rubygems'
require 'open-uri'
require 'JSON'

Jello::Mould.new do |paste, board|
  
  if paste =~ %r{^http://.*}
    uri = $&
    unless paste =~ %r{^http://tr.im}
      uri = CGI::escape uri
      
      # Feel free to copy this Mould to your ~/.jello directory and hardcode
      # in your username and password, if you don't feel like having your
      # username and password in your shell history.
      params = {}
      params[:username] = ENV['TRIM_USERNAME'] if ENV['TRIM_USERNAME']
      params[:password] = ENV['TRIM_PASSWORD'] if ENV['TRIM_PASSWORD']
      params[:url] = uri
      
      shortener = 'http://tr.im/api/trim_url.json?' +
        params.to_a.map {|a| a.join '=' }.join('&')
      
      reply = open(shortener).read
      short = JSON.parse reply
      short['url']
    end
  end
  
end