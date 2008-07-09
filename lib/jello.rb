require 'jello/pasteboard'

class Jello < Pasteboard
  def initialize opts = {}, &block
    @opts = {:verbose => false, :period => 0.2}.merge(opts)
    @on_paste = nil
    on_paste &block if block_given?
    @last_pasted = nil
  end
  
  def on_paste &block
    @on_paste = block
  end
  
  def start
    STDOUT.puts 'Watching pasteboard' if @opts[:verbose]
    begin
      while true
      
        if (paste = self.gets) != @last_pasted
          STDOUT.puts "Processing [#{paste}]" if @opts[:verbose]
          
          case @on_paste.arity
          when 1
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
    raise Interrupt
  end
end
