require 'jello/pasteboard'

class Jello
  def initialize opts = {}, &block
    @opts = {:verbose => false, :period => 0.2}.merge(opts)
    @on_paste = block
    @last_pasted = nil
    @pasteboard = Pasteboard.new
  end
  
  def on_paste &block
    raise LocalJumpError, "no block given" unless block_given?
    @on_paste = block
  end
  
  def start
    STDOUT.puts 'Watching pasteboard' if @opts[:verbose]
    begin
      while true
      
        if (paste = @pasteboard.gets) != @last_pasted
          STDOUT.puts "Processing [#{paste}]" if @opts[:verbose]
          
          if @on_paste.arity == 1
            @on_paste[paste]
          else
            @on_paste[paste, self]
          end
          
          @last_pasted = paste
        end
      
        sleep @opts[:period]
      end
    rescue Interrupt
      STDOUT.puts "\nClosing pasteboard watcher..." if @opts[:verbose]
      exit
    end
  end
  
  def stop
    raise Interrupt # …
  end
  
  def method_missing meth, *args
    @pasteboard.send meth, *args
  end
end
