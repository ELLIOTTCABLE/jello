module Kernel
  def forever &block
    __forever__(&block ||= lambda {})
  end
  
  def __forever__
    begin
      while true
        yield
      end
    rescue Interrupt
      exit
    end
  end
  
  # Execute some code without any warnings
  def silently
    old_verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = old_verbose
  end
  
end
