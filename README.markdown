Jello
=====

Because everybody likes "paste & jello" sandwiches, right? I know I did when I
was a kid.

Jello is a simple library to watch the OS X pasteboard and do something on
every paste.

    require 'jello'

    Jello.new do |paste|
      system "say 'You pasted #{paste}'"
    end

For example, to watch for URLs copied, and then shorten the URL and replace
the long URL with the shortened one:
    
    require 'open-uri'
    require 'jello'

    Jello.new :verbose => true do |paste, board|

      case paste

      when %r%^http://.*%
        uri = $&
        uri.gsub! /#/, '%23'
        next if uri =~ %r%^http://bit.ly%

        shortener = 'http://bit.ly/api?url=' + uri

        short = open(shortener).gets.chomp
        board.puts short

      end

    end.start
    

A few things to note:

 - In the block context, `#puts` and `#gets` are commandeered for the
   pasteboard object — use `STDOUT.puts` and `STDIN.gets` respectively if you
   need terminal interaction in the block context to be safe.

 - Creating a Jello block doesn't actually do anything by itself - you need to
   act on the paste itself. Test against contents and conditionally run code,
   whatever you want.