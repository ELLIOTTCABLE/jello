class Pasteboard
  def gets
    %x[pbpaste].chomp
  end
  
  def puts something
    out = IO::popen 'pbcopy', 'w+'
    out.print something
    out.close
    something
  end
end
