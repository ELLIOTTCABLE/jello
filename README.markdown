Jello
=====
Because everybody likes "paste & jello" sandwiches, right? I know I did when I
was a kid.

Jello is a simple library to watch the OS X pasteboard and do something on
every paste.

    require 'jello'

    Jello::Mould.new do |paste|
      system "say 'You pasted #{paste}'"
    end

    Jello.start!

For example, to watch for URLs copied, and then shorten the URL and replace
the long URL with the shortened one, write a short mould like the following:

    require 'open-uri'
    require 'jello'

    Jello::Mould.new do |paste|

      if paste =~ %r{^http://.*}
        uri = $&
        uri.gsub! /#/, '%23'
        unless uri =~ %r{^http://bit.ly}
          shortener = 'http://bit.ly/api?url=' + uri
          open(shortener).gets.chomp
        else
          nil
        end
      end

    end

    Jello.start! :verbose => true

Moulds can even be stacked:

    require 'jello'

    Jello::Mould.new do |paste|
      paste += '123'
    end

    Jello::Mould.new do |paste|
      paste += '456'
    end

    Jello.start! :verbose => true

Jello also provides a binary - if you have some moulds you use often, you can
throw them in your `~/.jello/` folder (as .rb files), and then run jello with
them:

    # Assuming ~/.jello/ contains foo.rb, bar.rb, and gaz/{one,two}.rb
    $ jello foo bar gaz
    # Now foo.rb, bar.rb, one.rb, and two.rb would be executed on incoming
    # pastes

You can also use pasteboards other than the general one (see `man pbcopy` for
more information about this):

    require 'jello'

    Jello::Mould.new do |paste|
      paste.gsub! /abc/, 'def'
    end

    Jello.start!

Finally, you can create a Jello [property list][plist] for [launchd][] that
will keep jello running all the time, even after you restart. Just run
`rake launchd` from the Jello distribution directory. (This requires that you
install the [LaunchDoctor][] gem first!)

  [launchd]: <http://en.wikipedia.org/wiki/Launchd> "launchd on Wikipedia"
  [plist]: <http://en.wikipedia.org/wiki/Property_list> "Property list on Wikipedia"
  [LaunchDoctor]: <http://github.com/elliottcable/launchdr> "elliottcable's launchdr on GitHub"

License
-------
This project is released for public usage under the terms of the very-permissive [ISC license][] (a
modern evolution of the MIT / BSD licenses); more information is available in [COPYING][].

   [ISC license]: <http://choosealicense.com/licenses/isc/> "Information about the ISC license"
   [COPYING]: <./COPYING.text>
