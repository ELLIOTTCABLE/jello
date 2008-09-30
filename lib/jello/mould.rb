module Jello
  
  ##
  # A hash of each pasteboard and the moulds that preform on that pasteboard.
  Moulds = Pasteboards.inject(Hash.new) {|h,pb| h[pb] = Array.new ; h }
  
  class Mould
    
    ##
    # This takes a block that will be executed on every paste received by
    # Jello.
    attr_accessor :on_paste
    
    ##
    # Acts as both a getter and a setter for the @on_paste attribute. If
    # passed a block, it sets that block as the @on_paste hook - else it
    # returns the current hook block.
    # 
    # @see @on_paste
    def on_paste &block
      if block_given?
        @on_paste = block
      else
        @on_paste
      end
    end
    
    ##
    # Creates a new Mould. Takes a block to be run on every paste.
    def initialize pasteboard = nil, &block
      @pasteboard = pasteboard || Pasteboard::General
      @on_paste = block
      
      Moulds[@pasteboard] << self
    end
    
    ##
    # We pass any missing methods on to the Pasteboard.
    # 
    # @see Jello::Pasteboard
    def method_missing meth, *args
      @pasteboard.send meth, *args
    end
    
  end
end