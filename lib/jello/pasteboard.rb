class Jello
  class Pasteboard
    
    ## 
    # The type of board to connect to. Available are the following:
    # 
    #  - :general [default]
    #  - :ruler
    #  - :find
    #  - :font
    # 
    # OS X offers various pasteboards for use, depending on what you want to
    # access. They're synced across the entire system. More information is
    # available under `man pbpaste`.
    # 
    # @see #gets
    # @see #puts
    attr_accessor :board
    
    ##
    # The type of data to request from the board. Available are the following:
    # 
    #  - :ascii [default]
    #  - :rtf  (Rich Text)
    #  - :ps (PostScript)
    # 
    # You're not guaranteed to receive that type, however - you'll receive it if
    # it's available, otherwise you'll receive the first in the above list that
    # is available. More information is available under `man pbpaste`.
    # 
    # @see #gets
    attr_accessor :format
    
    ##
    # This creates a new Pasteboard instance, connected to one of the available
    # Mac OS X pasteboards.
    # 
    # @see #gets
    # @see #puts
    def initialize options = {}
      @board ||= options[:board]
      @format ||= options[:format]
    
      yield self if block_given?
    end
    
    ##
    # This method gets the latest paste from the selected pasteboard,
    # of the selected format (if possible - see `#format`).
    # 
    # @see @board
    # @see @format
    def gets
      command = 'pbpaste'
      command << " -pboard #{@board}" if @board
      %x[#{command}].chomp
    end
    
    ##
    # This method puts a new entry into the selected pasteboard. Format is
    # automatically deduced from the headers of your string (see `man pbpaste`
    # for more info.)
    # 
    # @see @board
    def puts something
      command = 'pbcopy'
      command << " -pboard #{@board}" if @board
      command << " -Prefer #{@format}" if @format
      out = IO::popen command, 'w+'
      out.print something
      out.close
      something
    end
  end
end