require 'jello/core_ext/kernel'
require 'jello/pasteboard'
require 'jello/mould'

module Jello
  Version = 2
  
  def self.start! options = {}
    options = {:verbose => false, :period => 0.5}.merge(options)
    
    forever do
      
      Moulds.each do |pasteboard, moulds|
        if (paste = pasteboard.gets) != pasteboard.last
          initial_paste = paste.dup
          
          puts "#{pasteboard.board} received: [#{initial_paste}]" if options[:verbose]
          moulds.each do |mould|
            modified = mould.on_paste[paste]
            paste = modified if modified.is_a?(String)
          end
          
          if paste.is_a?(String) and paste != initial_paste
            puts " --> [#{paste}]" if options[:verbose]
            print "\a" if options[:feedback]
            pasteboard.puts paste 
          end
        end
      end
      
      sleep options[:period]
    end
  end
  
  def self.stop!
    raise Interrupt # …
  end
  
end
