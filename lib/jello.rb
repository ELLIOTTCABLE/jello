require 'jello/core_ext/kernel'
require 'jello/pasteboard'
require 'jello/mould'

module Jello
  Version = 2
  
  def self.start options = {}
    options = {:verbose => false, :period => 0.5}.merge(options)
    
    forever do
      
      Moulds.each do |pasteboard, moulds|
        # puts "DEBUG #{pasteboard.board.inspect} :now => [#{pasteboard.gets.inspect}], :last => [#{pasteboard.last.inspect}]"
        if (paste = pasteboard.gets) != pasteboard.last
          initial_paste = paste.dup
          
          puts "#{pasteboard.board} received: [#{initial_paste}]"
          moulds.each do |mould|
            paste = mould.on_paste[paste]
          end
          
          if paste and paste != initial_paste
            puts " --> [#{paste}]"
            pasteboard.puts paste 
          end
        end
      end
      
      sleep options[:period]
    end
  end
  
  def self.stop
    raise Interrupt # …
  end
  
end
